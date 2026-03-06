# dona-edu-api-docs

This README is for the **dona-edu-api-docs** repository, which manages the **API contract** for the Dona Edu system using **OpenAPI 3.0.3**.

## 1. Purpose

This repository is used to:
- centrally define the full API contract of the system;
- split paths and schemas by domain for easier maintenance;
- lint and bundle the spec before publishing documentation;
- generate the bundled OpenAPI file in the `docs/` directory for documentation viewing or integration with other tools.

The root spec is located at `src/openapi.yaml`, using OpenAPI `3.0.3`, with the title `Dona edu API` and the current version `0.1.0`.

## 2. Main Technologies

- **OpenAPI 3.0.3** for API specification.
- **Redocly CLI** for linting and bundling the spec.
- **Prism CLI** in the `Dockerfile` for mocking APIs from the OpenAPI file on port `4010`.

## 3. Project Structure

```text
.
├── .github/workflows/        # CI/CD workflows
├── docs/                     # bundled documentation output
├── src/
│   ├── openapi.yaml          # root spec file
│   ├── paths/                # path definitions split by domain
│   └── components/
│       ├── schemas/          # shared request/response schemas
│       ├── responses/        # reusable error responses
│       └── security.yaml     # security schemes
├── Dockerfile
├── package.json
└── README.md
```

## 4. How the Spec Is Organized

### 4.1 Root spec

`src/openapi.yaml` is the main entry point of the project. It defines:
- `info`
- `servers`
- `tags`
- `paths`
- `components`
- global `security`

In particular:
- `paths` points to `./paths/index.yaml`
- `components.securitySchemes` points to `./components/security.yaml`
- `components.schemas` points to `./components/schemas/index.yaml`
- `components.responses` points to `./components/responses/errors.yaml`

### 4.2 Paths split by domain

`src/paths/index.yaml` maps each URL group to a dedicated domain file, for example:
- `auth.yaml`
- `admin.yaml`
- `rooms.yaml`
- `contests.yaml`
- `problems.yaml`
- `testcases.yaml`
- `submissions.yaml`
- `leaderboard.yaml`
- `health.yaml`
- `dashboard.yaml`

This structure helps the team update APIs by business domain without working inside one large file.

### 4.3 Schemas split by domain

`src/components/schemas/index.yaml` acts as the export layer for schemas from child files such as:
- `auth.yaml`
- `admin.yaml`
- `user.yaml`
- `room.yaml`
- `contest.yaml`
- `problem.yaml`
- `testcase.yaml`
- `submission.yaml`
- `leaderboard.yaml`
- `dashboard.yaml`
- `common.yaml`

### 4.4 Security

The repository currently defines `BearerAuth` as an HTTP Bearer scheme with `JWT` format. The root spec applies this security globally.

## 5. Current API Groups

In `src/openapi.yaml`, the project currently defines the following tags:
- Auth
- Admin
- Users
- Rooms
- Contests
- Problems
- Testcases
- Submissions
- Leaderboard
- Health
- Dashboard

## 6. Environment Setup

Minimum requirements:
- Node.js
- npm

Install dependencies:

```bash
npm install
```

Note that this repository is a contract/documentation repository, not a backend runtime service. Its main purpose is editing specs, linting, bundling, and mocking when needed.

## 7. Common Commands

### Lint the OpenAPI spec

```bash
npm run lint
```

This runs:

```bash
redocly lint src/openapi.yaml
```

### Bundle the documentation

```bash
npm run bundle
```

This generates:

```text
docs/openapi.bundle.yaml
```

### Full build

```bash
npm run build
```

This is equivalent to:

```bash
npm run lint && npm run bundle
```

All scripts are defined directly in `package.json`.

## 8. Mock API with Docker

The current `Dockerfile` uses `node:20-alpine`, installs `@stoplight/prism-cli` globally, exposes port `4010`, and runs:

```bash
prism mock /app/openapi.yaml -h 0.0.0.0 -p 4010 --cors
```

This is useful when the frontend team needs a quick mock server based on the OpenAPI spec before the backend is ready.

Example usage:

```bash
docker build -t dona-edu-api-docs .
docker run --rm -p 4010:4010 dona-edu-api-docs
```

## 9. Recommended API Update Workflow

When adding or changing an API, the recommended order is:

1. Update the related path in `src/paths/*.yaml`.
2. Update or add schemas in `src/components/schemas/*.yaml`.
3. Check `src/components/schemas/index.yaml` if you added a new schema.
4. Check `src/paths/index.yaml` if you added a new endpoint group or domain.
5. Run `npm run lint`.
6. Run `npm run bundle` to update `docs/openapi.bundle.yaml`.

## 10. Contract Conventions for This Repository

To keep the project consistent, follow these conventions:
- Group endpoints by business domain.
- Separate request/response schemas and reuse them via `$ref`.
- Reuse error responses from `components/responses/errors.yaml`.
- Add `example` values for important requests and responses so Redoc renders clearer documentation.
- For list APIs, keep query parameter naming consistent across domains, for example `query`, `page`, `size`, and `sort`.
- For paginated objects, reuse the shared `Paging` schema from `common.yaml` through the schema index.

## 11. Which File Should You Update?

- Update a specific endpoint: `src/paths/<domain>.yaml`
- Update request/response models: `src/components/schemas/<domain>.yaml`
- Add a reusable schema: add it in the domain schema file, then export it in `src/components/schemas/index.yaml`
- Add a new endpoint inside an existing domain: update the related domain file
- Add a completely new domain/path group: update both `src/paths/<domain>.yaml` and `src/paths/index.yaml`
- Adjust shared JWT security: check `src/components/security.yaml` and `src/openapi.yaml`

## 12. Future README Improvements

The current repository README is still very minimal. In the future, it can be improved with:
- a documentation preview link;
- branch and pull request workflow;
- `operationId` naming conventions;
- versioning guidelines;
- response example writing guidelines;
- a pre-merge checklist.

## 13. Summary

`dona-edu-api-docs` is a repository dedicated to managing the API contract for the Dona Edu system in a modular way:
- one root spec;
- paths split by domain;
- schemas split by domain;
- linting and bundling with Redocly;
- quick mocking support through Prism and Docker.

This repository is suitable for frontend, backend, and QA teams to work against a single, shared API contract during system development.
