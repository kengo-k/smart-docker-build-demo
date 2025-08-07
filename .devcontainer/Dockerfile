# Smart Docker Build Demo: ローカル開発環境用（VS Code Dev Container）
# image: react-calculator-devcontainer
# imageTagsOnTagPushed: null
# imageTagsOnBranchPushed: ["v1.0.2"]
# watchFiles: ["Dockerfile", ".devcontainer/**/*"]
FROM node:18-alpine

RUN apk add --no-cache \
    git \
    curl \
    wget \
    vim \
    nano \
    htop \
    tree \
    jq \
    && rm -rf /var/cache/apk/*

WORKDIR /workspace

RUN npm install -g \
    @vue/cli \
    create-react-app \
    typescript \
    ts-node \
    nodemon \
    eslint \
    prettier \
    jest \
    @testing-library/jest-dom

RUN addgroup -g 1000 nodeuser && \
    adduser -D -s /bin/sh -u 1000 -G nodeuser nodeuser

RUN chown -R nodeuser:nodeuser /workspace

USER nodeuser

SHELL ["/bin/sh", "-c"]

CMD ["sleep", "infinity"] 