# Terraform Standards

## ディレクトリ構造

環境ごとの分離と、共通リソースの分離を原則とします。

```text
infra/terraform/
├── cmn/                           # 全環境共通リソース（書く環境tfstate保存用S3作成用）
│   ├── main.tf
│   ├── locals.tf
│   └── outputs.tf
├── dev/                           # 開発環境用リソース
│   ├── main.tf                    # メイン構成、バージョン、プロバイダ指定、モジュール呼び出し
│   ├── backend.tf                 # State設定
│   ├── locals.tf                  # 変数定義(variablesは基本使わなず、localsを使用)
│   └── outputs.tf
├── stg/                           # ステージング環境用リソース（将来用）
├── prd/                          # 本番環境用リソース（将来用）
└── modules/                       # 環境構築用モジュールディレクトリ
    └── create_env/                # 環境構築用モジュール(不要なインタフェース設計を減らすために単一モジュールを使用)
        └── <AWSサービス名>.tf/     # AWSサービスごとの環境構築用Terraform定義ファイル

## State管理

- **バックエンド**: S3バケットを使用し、ステートファイルを一元管理します。
- **ロック**: S3にあるロックファイル（推奨）。
- **暗号化**: S3のデフォルト暗号化を使用

## 命名規則

- **リソース名**: `[project]-[env]-[resource-name]` の形式を基本とします。
  - 例: `surveillance-dev-images-bucket`
- **タグ付け**: 全リソースに以下の共通タグを付与します。
  - `Project`: プロジェクト名
  - `Environment`: `dev`, `stg`, `prd`, `cmn`
  - `ManagedBy`: `terraform`

## コーディング規約

### 変数 (`locals.tf`)
- 基本的に`variables`を使用せず、localsを使用。（将来パラメータが多くなったらを階層化して定義できるようにするため）
- すべての変数には説明コメントを明記します。

### 出力 (`outputs.tf`)
- 他のモジュールやアプリケーションから参照が必要な値（ARN, エンドポイント等）のみを出力します。
- センシティブな値は `sensitive = true` を設定します。

### セキュリティ
- **シークレット**: APIキーやパスワードはコードにハードコードせず、AWS Secrets Manager または SSM Parameter Store を使用します。
- **IAM**: 必要最小限の権限（Least Privilege）を原則としてポリシーを設計します。ワイルドカード（`*`）の使用は避けます。

## バージョン管理

- **Terraformバージョン**: `main.tf` の`terraform`ブロックでバージョンを固定する。
- **Providerバージョン**: `main.tf` の`terraform`の`required_providers` ブロックでバージョンを固定し、予期せぬ破壊的変更を防ぎます。

---
_Document patterns, not every resource. New modules should follow these patterns._
