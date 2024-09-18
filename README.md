# sctp-ce6-mod3.11

[![Deploy to Amazon ECS](https://github.com/tsanghan/sctp-ce6-mod3.11/actions/workflows/aws-ecs-ecr.yaml/badge.svg)][def]

[def]: https://github.com/tsanghan/sctp-ce6-mod3.11/actions/workflows/aws-ecs-ecr.yaml

The command to create this GitHub repository.

```
gh repo create sctp-ce6-mod3.11 --public --license mit --add-readme --gitignore Terraform
```

The `.gitignore` file have to be manually adjusted by adding content of `Python` gitignore file (https://github.com/github/gitignore/blob/main/Python.gitignore) and content of `Node` gitignore file (https://github.com/github/gitignore/blob/main/Node.gitignore).

The creation of `dev` environment in GitHub Action is by the following `gh` command with `api` call.

```
gh api --method PUT -H "Accept: application/vnd.github+json" repos/tsanghan/sctp-ce6-mod3.11/environments/dev
```
All necessary `secrets` and `variable` for `dev` Environment are created as follow.

```
 gh variable set AWS_REGION --body "ap-southeast-1" -e dev
 gh variable set ECR_REPOSITORY --body "tsanghan-ce6/hello-app" -e dev
 gh variable set ECS_SERVICE --body "tsanghan-ce6-service" -e dev
 gh variable set ECS_CLUSTER --body "tsanghan-ce6-ecs-cluster" -e dev
 gh variable set CONTAINER_NAME --body "tsanghan-ce6-container" -e dev
 gh variable set REGISTRY_ALIAS --body "u2q1a2y8" -e dev
```
Key ID and Access Key are set with the following command template.
```
 gh secret set SOME_NAME --body "${SOME_VALUE}" -e dev
```
Replace `SOME_NAME` and `SOME_VALUE` accordingly.