# Keycloak

Keycloak is a popular Open ID Connect (OIDC) Identity Provider.

The TRE-FX stack uses OIDC Token auth for:
- The Workflow Executor (i.e. Hutch) to communicate with the TRE Controller API
- The Workflow Executor (i.e. Hutch) to communicate with the Intermediary Store (MinIO)

Hutch can bypass the need for OIDC Token auth when in Standalone mode (i.e. not communicating with a TRE Controller API) and/or if access credentials are passed directly for the Intermediary Store (e.g. at job submission) (or configured in the `StoreDefaults` config).

To use KeyCloak, some configuration is needed.

The `docker-compose` in the Hutch repo has an example of a keycloak instance suitable for development. This instance uses the `postgreSQL` service to store its data. Create a database on this service called `bitnami_keycloak`. Then when keycloak starts, it will populate the database with tables.

There is some futher configuration once this is running before it can be used.

## Further configuration

### Create a Realm

Minio in the sample `docker-compose` expects the realm to be called `hutch-dev`.

### Create (a) User(s)

Both MinIO and the TRE Controller API currently expect user tokens, so Hutch currently must have a user to get tokens for, which it does via the Password Grant Flow.

Additionally it's worth being aware that the TRE Controller expects an **access token** (so in future Hutch could use the Client Credentials flow), but Minio requires an **identity token**.

In the realm created above, navigate to the Users tab and click "Add user". Give the user a username and click "Save". The new user will now appear in the Users tab.

#### Add a password

In the user's settings, go to the "Credentials" tab and click "Set password". Enter and verify a password and set "Temporary" to "off".

#### Add required MinIO attributes to user

MinIO by default expects a claim in the user called `policy`. This is an array which can contain one or more of the following: `consoleAdmin`, `readonly`, `readwrite`, `diagnostics` or `writeonly`. In the "Attributes" tab of the user created above, click "Add an attribute" and enter "policy" in the "Key" box, followed by one of the options previously listed in the "Value" box. To add another "policy", click "Add an attribute" underneath and once again enter "policy" in the "Key" box with another of the choices in the "Value" box.

### Create a Client for Hutch

NOTE: You may wish to re-use the same client for Hutch and MinIO, since MinIO will only accept token from Hutch if they were requested using the MinIO Client Credentials.

General Settings:

- type: `OpenID Connect`
- client id: e.g. `hutch-agent`

Capability Config:

- Client authentication: `ON`
- Authentication Flow:
  - [x] Direct access grants
    - This is OIDC's "Resource Owner Password Credentials Grant" and is currently all Hutch supports, because MinIO and the TRE Controller API expect user tokens, not client ones.

:::caution
Do not check "Service account roles" or keycloak will try to log into MinIO as a service account, rather than the user's account. This would require additional configuration.
:::

### Add a Client Scope for the Client

:::note
This advice assumes the client is called `hutch-agent`. Substitute `hutch-agent` if using another client name.
:::

The MinIO instance in the `docker-compose` file expects a scope called `openid`. To create this, go to the "Client scopes" tab in the keycloak console and click "Create client scope". Call it "openid" and click "Save". Now create a mapper for the `policy` user attribute by going to the "Mappers" tab on the new scope and clicking "Configure a new mapper". Select "User Attribute" from the menu.

Give the mapper the following settings:

- Name: openid-mapper
- User Attribute: policy
- Token Claim Name: policy
- Claim JSON Type: String
- Add to ID token: on
- Add to access token: on
- Add to userinfo: on
- Multivalued: on
- Aggregate attribute values: on

Then click "Save".

Go back to the Client scopes tab and back into openid. Navigate to the scopes tab and click "Assign role". Select `default-role-hutch-dev` and click "Assign".

Now go to the "Clients" tab and select the `hutch-agent`. Go to the "Client Scopes" tab **in the middle of the screen** and click "Add client scope". Select `openid` from the menu and click "Add" choosing "Default" from the drop-down menu.

Login Settings:

not sure what is needed here as we aren't doing an interactive user login flow...

- Root URL should be Hutch's configured URL e.g. for development `http://host.docker.internal:5209`
- Most other settings are URLs and for development can just be wildcarded with `*`

### Configure Hutch

After creating the client, the Credentials tab can be used to generate or view the client secret.

Hutch can then be configured with

- the keycloak URL e.g. `localhost:9090`
- its client id e.g. `hutch-agent`
- its client secret
- a username and password for a user to get a token on behalf of
