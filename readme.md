# Opendkim docker container


## Build

```
docker build . -t opendkim
```

Or you can use directly our image `adiandev/opendkim`

## Usage


```
docker run -v $(pwd)/dkim-keys:/etc/opendkim/keys --name dkim -v -e HOST=your_domain adiandev/opendkim
```

If keys dont exist automatically will generate them and print the public key on stdout.


## Usage (docker compose) + opendkim

```
version: '2'
services:
  postfix.localhost:
    image: adiandev/postfix
    container_name: postfix
    networks:
      postfix-net:
      dkim-net:
    environment:
      ADMIN_EMAIL: your_email
      DKIM_HOST: dkim
    volumes:
      - ./postfix-data:/var/spool/postfix
      - ./postfix-logs:/var/log/postfix
    hostname: "postfix.localhost"
  dkim:
    image: adiandev/opendkim
    container_name: dkim
    networks:
      dkim-net:
    environment:
      HOST: "postfix.localhost"
      SELECTOR: "mailselector"
    volumes:
      - ./dkim-keys:/etc/opendkim/keys
      - ./dkim-logs:/var/log/dkim

networks:
  postfix-net:
  dkim-net:
```

## Environment variables

+ HOST (Required): Domain name.
+ SELECTOR (Optional, defaults to "mail"): Selector to the dns record.

