FROM golang:1.12.1-alpine3.9 AS builder
LABEL maintainer="Brandon McNama <brandonmcnama@outlook.com>"

RUN apk add git upx binutils

ARG TERRAFORM_VERSION=0.11.14

ADD https://github.com/hashicorp/terraform/archive/v${TERRAFORM_VERSION}.zip terraform.zip

RUN unzip terraform.zip && \
  cd terraform-${TERRAFORM_VERSION} && \
  go install ./tools/terraform-bundle && \
  strip $(which terraform-bundle) && \
  upx $(which terraform-bundle)

FROM alpine:3.9 

RUN apk add ca-certificates

COPY --from=builder /go/bin/terraform-bundle /bin/terraform-bundle
