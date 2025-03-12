build:
	yarn --cwd backstage build:backend
	docker image build backstage -f backstage/packages/backend/Dockerfile --tag backstage:latest	
deploy:
	kind create cluster -n backstage --config kind-config.yaml
	kind load docker-image -n backstage backstage:latest
	helm install backstage backstage-chart -n backstage --create-namespace

clean:
	kind delete cluster -n backstage

azure-deploy:
	yarn --cwd backstage build:backend
	docker image build backstage -f backstage/packages/backend/Dockerfile --tag prefappacr.azurecr.io/backstage:latest
	docker push prefappacr.azurecr.io/backstage:latest
	helm install backstage backstage-chart -n backstage --create-namespace


init: clean build deploy 

redeploy: clean deploy
