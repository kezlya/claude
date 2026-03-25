#!/usr/bin/env python3
"""
Read-only Skool community scraper.
Uses authenticated session cookies to fetch community data via the __NEXT_DATA__ JSON blob.

Usage:
    python3 utils/skool_scraper.py about     # Community info, description, stats
    python3 utils/skool_scraper.py posts      # Latest posts from the feed
    python3 utils/skool_scraper.py members    # Leaderboard / member list
    python3 utils/skool_scraper.py all        # Everything above

Reads credentials from utils/.env (gitignored).
"""

import json
import os
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path

ENV_PATH = Path(__file__).parent / ".env"


def load_env():
    env = {}
    if not ENV_PATH.exists():
        print(f"ERROR: {ENV_PATH} not found. Create it with your Skool cookies.", file=sys.stderr)
        sys.exit(1)
    for line in ENV_PATH.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        key, _, value = line.partition("=")
        env[key.strip()] = value.strip()
    return env


def fetch_page(slug, path=""):
    """Fetch a Skool page and return the parsed __NEXT_DATA__ pageProps."""
    env = load_env()
    url = f"https://www.skool.com/{slug}/{path}".rstrip("/")
    cookies = (
        f"client_id={env['SKOOL_CLIENT_ID']}; "
        f"auth_token={env['SKOOL_AUTH_TOKEN']}; "
        f"aws-waf-token={env['SKOOL_WAF_TOKEN']}"
    )
    result = subprocess.run(
        [
            "curl", "-s", url,
            "-H", "accept: text/html",
            "-b", cookies,
            "-H", "user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                  "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36",
            "-w", "\n__HTTP_CODE__:%{http_code}",
        ],
        capture_output=True, text=True,
    )
    output = result.stdout
    # Extract HTTP code
    code_match = re.search(r"__HTTP_CODE__:(\d+)", output)
    http_code = int(code_match.group(1)) if code_match else 0
    if http_code == 403:
        print("ERROR: 403 Forbidden - cookies likely expired. Run: utils/refresh_cookies.sh", file=sys.stderr)
        sys.exit(1)
    if http_code != 200:
        print(f"ERROR: HTTP {http_code} from {url}", file=sys.stderr)
        sys.exit(1)

    match = re.search(r'<script id="__NEXT_DATA__" type="application/json">(.*?)</script>', output)
    if not match:
        print("ERROR: Could not find __NEXT_DATA__ in page. Page structure may have changed.", file=sys.stderr)
        sys.exit(1)

    data = json.loads(match.group(1))
    return data["props"]["pageProps"]


def cmd_about(slug):
    pp = fetch_page(slug, "about")
    meta = pp["currentGroup"]["metadata"]

    print("=" * 60)
    print(f"COMMUNITY: {meta.get('displayName', 'Unknown')}")
    print(f"URL: https://www.skool.com/{slug}")
    print("=" * 60)

    print(f"\nDescription: {meta.get('description', '(none)')}")
    print(f"Privacy: {'Public' if meta.get('privacy') == 1 else 'Private'}")
    price = meta.get("price")
    print(f"Price: {'Free' if not price else f'${price}/month'}")
    print(f"Plan: {meta.get('plan', 'unknown')}")
    print(f"Color: {meta.get('color', 'none')}")
    print(f"Initials: {meta.get('initials', 'none')}")

    print(f"\n--- Stats ---")
    print(f"Total Members: {meta.get('totalMembers', 0)}")
    print(f"Online Now: {meta.get('totalOnlineMembers', 0)}")
    print(f"Total Posts: {meta.get('totalPosts', 0)}")
    print(f"Total Admins: {meta.get('totalAdmins', 0)}")
    print(f"Pending Requests: {meta.get('totalRequests', 0)}")

    # About page / landing page description
    lp = meta.get("lpDescription", "")
    if lp:
        print(f"\n--- About Page ---")
        print(lp)

    # Owner info
    owner = meta.get("owner", {})
    if owner:
        if isinstance(owner, str):
            owner = json.loads(owner)
        om = owner.get("metadata", {})
        if isinstance(om, str):
            om = json.loads(om)
        print(f"\n--- Owner ---")
        print(f"Name: {om.get('name', owner.get('name', '?'))}")
        print(f"Bio: {om.get('bio', '(none)')}")
        print(f"LinkedIn: {om.get('linkLinkedin', om.get('link_linkedin', ''))}")

    # Tabs
    tabs = meta.get("tabs", {})
    if isinstance(tabs, str):
        tabs = json.loads(tabs)
    if tabs:
        visible = [k for k, v in tabs.items() if isinstance(v, dict) and v.get("visible")]
        hidden = [k for k, v in tabs.items() if isinstance(v, dict) and not v.get("visible")]
        print(f"\nVisible tabs: {', '.join(visible) if visible else 'none'}")
        print(f"Hidden tabs: {', '.join(hidden) if hidden else 'none'}")

    return meta


def cmd_posts(slug):
    pp = fetch_page(slug, "")
    rd = pp.get("renderData", {})
    post_trees = rd.get("postTrees", [])
    total = rd.get("total", 0)
    pinned = rd.get("totalPinnedPosts", 0)

    print("=" * 60)
    print(f"POSTS (showing {len(post_trees)} of {total}, {pinned} pinned)")
    print("=" * 60)

    for pt in post_trees:
        post = pt.get("post", {})
        pm = post.get("metadata", {}) if isinstance(post.get("metadata"), dict) else {}
        user = pt.get("user", post.get("user", {}))
        um = user.get("metadata", {}) if isinstance(user.get("metadata"), dict) else {}

        title = pm.get("title", post.get("title", "(no title)"))
        content = pm.get("content", post.get("body", ""))
        author = um.get("name", um.get("bio", user.get("name", "?")))
        upvotes = pm.get("upvotes", 0)
        is_pinned = pm.get("pinned", 0)
        created = post.get("createdAt", "")
        comments = pm.get("commentCount", post.get("commentCount", 0))

        pin_tag = " [PINNED]" if is_pinned else ""
        print(f"\n{'---'} {title}{pin_tag} {'---'}")
        print(f"By: {author}")
        if created:
            print(f"Date: {created[:10]}")
        print(f"Upvotes: {upvotes} | Comments: {comments}")
        if content:
            # Clean up Skool markup
            clean = re.sub(r'\[/?(?:ol|ul|li|b|i|h\d)[^\]]*\]', '', content)
            print(f"Content: {clean[:500]}")
        print()

    return post_trees


def cmd_members(slug):
    pp = fetch_page(slug, "members")
    rd = pp.get("renderData", {})

    print("=" * 60)
    print("MEMBERS")
    print("=" * 60)

    # Try multiple possible data shapes
    for key, section in rd.items():
        if not isinstance(section, dict):
            continue
        users = section.get("users") or []
        if users:
            print(f"\n--- {key} ({len(users)} users) ---")
            for u in users:
                um = u.get("metadata", {})
                name = um.get("name", u.get("name", "?"))
                bio = um.get("bio", "")
                points = um.get("points", 0)
                print(f"  {name} - {points} pts - {bio[:80]}")

    # Also show from group metadata
    meta = pp.get("currentGroup", {}).get("metadata", {})
    print(f"\nTotal members: {meta.get('totalMembers', '?')}")
    print(f"Online now: {meta.get('totalOnlineMembers', '?')}")


def cmd_all(slug):
    cmd_about(slug)
    print("\n")
    cmd_posts(slug)
    print("\n")
    cmd_members(slug)


def main():
    env = load_env()
    slug = env.get("SKOOL_COMMUNITY_SLUG", "clearhead-7768")

    commands = {
        "about": cmd_about,
        "posts": cmd_posts,
        "members": cmd_members,
        "all": cmd_all,
    }

    if len(sys.argv) < 2 or sys.argv[1] not in commands:
        print(f"Usage: {sys.argv[0]} <{'|'.join(commands.keys())}>")
        sys.exit(1)

    commands[sys.argv[1]](slug)


if __name__ == "__main__":
    main()
