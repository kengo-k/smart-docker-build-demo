# Smart Docker Build Demo: ローカル開発環境用（VS Code Dev Container）
# image: react-calculator-devcontainer
# imageTagsOnTagPushed: null
# imageTagsOnBranchPushed: ["devcontainer"]
# watchFiles: ["Dockerfile", ".devcontainer/**/*"]
FROM node:18-alpine

# 開発ツールをインストール
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

# 作業ディレクトリを設定
WORKDIR /workspace

# グローバルパッケージをインストール
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

# 非rootユーザーを作成（セキュリティ向上）
RUN addgroup -g 1000 nodeuser && \
    adduser -D -s /bin/sh -u 1000 -G nodeuser nodeuser

# 権限を設定
RUN chown -R nodeuser:nodeuser /workspace

# ユーザーを切り替え
USER nodeuser

# デフォルトシェルを設定
SHELL ["/bin/sh", "-c"]

# コンテナ起動時のコマンド（開発サーバーは起動しない）
CMD ["sleep", "infinity"] 