# GitLab CI/CD Templates

This repository contains reusable GitLab CI/CD templates for use in your `.gitlab-ci.yml` files.

---

## Contents

- [How-To Guides](#how-to-guides)
  - [Include a Template in Your Job](#include-a-template-in-your-job)
  - [Use an Included Template](#use-an-included-template)
  - [Use Anchors and References](#use-anchors-and-references)
- [References](#references)


## How-To Guides

### 1. Include a Template in Your Job

GitLab provides a keyword to include templates and use them in your `.gitlab-ci.yml` file.

💡 The `include` keyword allows you to reference content declared in an external `.yml` or `.yaml` file—either locally or remotely. For more details, refer to the [GitLab documentation on include](https://docs.gitlab.com/ee/ci/yaml/#include).

**Example:**

```yaml
stages:
  - test

include:  
  - '/gitlab-ci/sonar-test-template.yml'
  - '/gitlab-ci/vault-template.yml'
```

### 2. Use an Included Template

💡 After including templates, note that all jobs within them are hidden by default. This means they are disabled unless explicitly enabled. If you run the pipeline in GitLab at this stage, it will not execute because the pipeline has no active jobs.
**Example:**

```yaml
.sonarqube:
  image: 
    name: sonarsource/sonar-scanner-cli:11
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"  # Defines the location of the analysis task cache
    GIT_DEPTH: "0"  # Tells git to fetch all the branches of the project, required by the analysis task
    SONAR_PROJECT_DIR: "."
  cache:
    key: "${CI_JOB_NAME}"
    paths:
      - .sonar/cache
  script: 
    - |
      sonar-scanner \
        -Dsonar.sources=${SONAR_PROJECT_DIR} \
        -Dsonar.projectKey="${SONAR_PROJECT_KEY}" \
        -Dsonar.qualitygate.wait="true" \
        -Dsonar.host.url="${SONAR_HOST_URL}" \
        -Dsonar.login="${SONAR_TOKEN}"

  allow_failure: true
```
To use these templates, you need to inherit their jobs using the `extends: job name` structure. For additional information, check the [GitLab documentation on extends](https://docs.gitlab.com/ee/ci/yaml/#extends) and [hiding jobs](https://docs.gitlab.com/ee/ci/yaml/#hide-jobs).

**Example:**

```yaml
stages:
  - test

include:  
  - '/gitlab-ci/sonar-test-template.yml'
  - '/gitlab-ci/vault-template.yml'

sonar:
  stage: test
  extends: .sonarqube

vault:
  stage: test
  extends: .vault
```

You can also override predefined variables or settings from the template while extending them.

**Example:**

Template (`sometemplate.yml`):

```yaml
variables:
  name: "denis"

script:
  - echo $name
```

Job (`job1.yml`):

```yaml
extends: sometemplate.yml

variables:
  name: "other"
```

In this example, the variable `name` is overridden in `job1.yml` to use a different value.

### 3. Use Anchors and References

GitLab CI/CD allows you to reuse configuration blocks with YAML anchors and references. This can simplify your pipeline configuration by avoiding duplication.

💡 Use `&` to define an anchor and `*` to reference it later. You can also use `!reference` to reuse predefined blocks from included templates. Learn more in the [GitLab documentation on anchors](https://docs.gitlab.com/ee/ci/yaml/#anchors).

**Example:**

Define an anchor for reusable scripts:

```yaml
.docker-registry: &docker-registry
  script: 
    - echo $CI_REGISTRY_PASSWORD | docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY
```

Reference it in a job:

```yaml
deploy:
  stage: deploy
  image: docker:20
  services:
    - docker:20-dind
  before_script:
    - !reference [.docker-registry, script]
  script:
    - docker build -t $IMAGE_TAG .
    - docker push $IMAGE_TAG
```


## References

- [GitLab CI/CD documentation](https://docs.gitlab.com/ee/ci/)
- [GitLab YAML includes](https://docs.gitlab.com/ee/ci/yaml/#include)
- [GitLab YAML extends](https://docs.gitlab.com/ee/ci/yaml/#extends)
- [GitLab YAML anchors](https://docs.gitlab.com/ee/ci/yaml/#anchors)
- [Optimize pipeline implementation using GitLab CI Templates](https://medium.com/globant/optimize-pipeline-implementation-using-gitlab-ci-templates-6eef54046231)

