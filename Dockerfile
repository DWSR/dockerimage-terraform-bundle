FROM golang:1.12.1-alpine3.9 AS builder

RUN apk add git

ARG TERRAFORM_VERSION=0.11.13

ADD https://github.com/hashicorp/terraform/archive/v${TERRAFORM_VERSION}.zip terraform.zip

RUN unzip terraform.zip && \
  cd terraform-${TERRAFORM_VERSION} && \
  go install ./tools/terraform-bundle

FROM alpine:3.9 

COPY --from=builder /go/bin/terraform-bundle /bin/terraform-bundle
