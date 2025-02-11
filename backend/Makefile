PROJECT_ID := calorie-tracker-444422
IMAGE := flask-api
REGION := us-central1

# Commands
build:
	@echo 'Building Docker image...'
	docker build --platform linux/amd64 -t $(IMAGE) .    

push:
	@echo 'Pushing Docker image...'
	docker tag $(IMAGE) gcr.io/$(PROJECT_ID)/$(IMAGE)
	docker push gcr.io/$(PROJECT_ID)/$(IMAGE)

deploy:
	@echo 'Deploying Docker image...'
	gcloud config set account petariliev2002@gmail.com
	gcloud config set project calorie-tracker-444422
	gcloud run deploy $(IMAGE) \
		--image gcr.io/$(PROJECT_ID)/$(IMAGE) \
		--region $(REGION) \
		--platform managed \
		--allow-unauthenticated \
	
all: build push deploy
	