# opentelemetry-demo

The goal of this example is to provide step-by-step instructions for creating a
solution that extends opentelemetry demo by providing additional context for the data it is reporting.

## Demo setup
1. Follow instructions at <https://opentelemetry.io/docs/demo/>
2. Create an agent principal in Cisco Observability Platform by navigating to `Configure->Databases and Hosts`, 
providing a name for your agent, and clicking on `Generate`. Note down the resulting `Credentials`
3. Add the following configuration to `src/otelcollector/otelcol-config-extras.yml`
    ```yaml
    extensions:
      oauth2client:
        client_id: APPD_OTELCOL_CLIENT_ID
        client_secret: APPD_OTELCOL_CLIENT_SECRET
        token_url: APPD_OTELCOL_TOKEN_URL
    exporters:
      otlphttp:
        endpoint: APPD_OTELCOL_ENDPOINT_URL
        auth:
          authenticator: oauth2client
    service:
      extensions: [ oauth2client ]
      pipelines:
        traces:
          exporters: [otlphttp]
        metrics:
          exporters: [otlphttp]
        logs:
          exporters: [otlphttp]
    ```
4. 