# Build a container via the command "make build"
# By Jason Gegere <jason@htmlgraphic.com>

NAME = imap-server
IMAGE_REPO = htmlgraphic
IMAGE_NAME = $(IMAGE_REPO)/$(NAME)
DOMAIN = htmlgraphic.com

all:: help


help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "     make run          - Create a container for $(NAME)"
	@echo "     make start        - Start the EXISTING $(NAME) container"
	@echo "     make stop         - Stop $(NAME) container"
	@echo "     make remove       - Remove $(NAME) container"
	@echo "     make build        - Build the $(NAME) image"
	@echo "     make data         - Build containers for persistent data"

#### MAIL SERVICE

run: 
	@echo "Run $(NAME)..."
	docker run -d --restart=always --volumes-from mailvol --volumes-from mailbase --name $(NAME) -p 0.0.0.0:25:25 -p 0.0.0.0:587:587 -p 0.0.0.0:143:143 dovecot:2.1.7

start:
	@echo "Starting $(NAME)..."
	docker start $(NAME)

stop:
	@echo "Stopping $(NAME)..."
	docker stop $(NAME)

remove: stop
	@echo "Removing $(NAME)..."
	docker rm $(NAME)

build:
	cd dovecot; docker build -t dovecot:2.1.7 .

data:	
	@echo "Creating data containers for IMAP Server..."
	docker run -v /srv --name mailvol ubuntu:14.04 
	cd mail-base; docker build --no-cache -t mail-base .
	docker run --name mailbase mail-base



#### BELOW NEEDS TO BE REFINED, SIMPLIFIED AND IMPROVED


rainloop: dovecot
	cd rainloop; docker build -t rainloop:1.6.9 .

mailpile: dovecot
	cd mailpile; docker build -t mailpile:latest .

owncloud: dovecot
	cd owncloud; docker build -t owncloud:7.0.2 .

run-rainloop:
	docker run -d -p 127.0.0.1:33100:80 rainloop:1.6.9

run-mailpile:
	docker run -d -p 127.0.0.1:33411:33411 mailpile:latest

run-owncloud:
	docker run -d -p 127.0.0.1:33200:80 -v /srv/owncloud:/var/www/owncloud/data owncloud:7.0.2 

run-all: run run-rainloop run-owncloud
