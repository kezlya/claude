CODE_DIR := $(HOME)/code
PROJECTS_FILE := projects/projects.yaml

# Clone all repos from projects.yaml
# Usage:
#   make clone-all              # Clone everything
#   make clone GROUP=cs         # Clone only the "cs" group
.PHONY: clone-all clone

clone-all:
	@python3 -c "\
	import yaml, os, subprocess;\
	data = yaml.safe_load(open('$(PROJECTS_FILE)'));\
	code = '$(CODE_DIR)';\
	for g in data['groups']:\
	    name = g['name'];\
	    gtype = g.get('type', '');\
	    if gtype in ('standalone', 'monorepo'):\
	        dest = os.path.join(code, name);\
	        origin = g.get('origin', '');\
	        if origin and not os.path.exists(dest):\
	            print(f'Cloning {name} -> {dest}');\
	            subprocess.run(['git', 'clone', origin, dest]);\
	        else:\
	            print(f'Skip {name} (exists)') if os.path.exists(dest) else None;\
	    else:\
	        for r in g.get('repos', []):\
	            origin = r.get('origin', '');\
	            if not origin: continue;\
	            dest = os.path.join(code, name, r['name']);\
	            if not os.path.exists(dest):\
	                os.makedirs(os.path.dirname(dest), exist_ok=True);\
	                print(f'Cloning {name}/{r[\"name\"]} -> {dest}');\
	                subprocess.run(['git', 'clone', origin, dest]);\
	            else:\
	                print(f'Skip {name}/{r[\"name\"]} (exists)');\
	"

clone:
	@if [ -z "$(GROUP)" ]; then echo "Usage: make clone GROUP=<name>"; exit 1; fi
	@python3 -c "\
	import yaml, os, subprocess;\
	data = yaml.safe_load(open('$(PROJECTS_FILE)'));\
	code = '$(CODE_DIR)';\
	grp = [g for g in data['groups'] if g['name'] == '$(GROUP)'];\
	if not grp: print('Group $(GROUP) not found'); exit();\
	g = grp[0];\
	gtype = g.get('type', '');\
	if gtype in ('standalone', 'monorepo'):\
	    dest = os.path.join(code, g['name']);\
	    origin = g.get('origin', '');\
	    if origin and not os.path.exists(dest):\
	        print(f'Cloning {g[\"name\"]} -> {dest}');\
	        subprocess.run(['git', 'clone', origin, dest]);\
	    else:\
	        print(f'Skip {g[\"name\"]} (exists)') if os.path.exists(dest) else None;\
	else:\
	    for r in g.get('repos', []):\
	        origin = r.get('origin', '');\
	        if not origin: continue;\
	        dest = os.path.join(code, g['name'], r['name']);\
	        if not os.path.exists(dest):\
	            os.makedirs(os.path.dirname(dest), exist_ok=True);\
	            print(f'Cloning {g[\"name\"]}/{r[\"name\"]} -> {dest}');\
	            subprocess.run(['git', 'clone', origin, dest]);\
	        else:\
	            print(f'Skip {g[\"name\"]}/{r[\"name\"]} (exists)');\
	"
