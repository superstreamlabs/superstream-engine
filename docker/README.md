<div align="center">

![full logo superstream](https://github.com/superstreamlabs/superstream-engine/assets/107035359/19dc2e40-a907-49ee-9faf-d6d707633d53)

<b>Improve And Optimize Your Kafka In Literally Minutes.<br>
Reduce Costs and Boost Performance by 75% Without Changing a Single Component or Your Existing Kafka!</b>

</div>

## Configure Environment Tokens

Edit the following variable in `docker-compose.yaml` file supplied by Superstream.
```yaml
superstream:
  ...
  environment:
    ACTIVATION_TOKEN: ""     # Enter the activation token required for services or resources that need an initial token for activation or authentication.
  ...
```

To deploy it, run the following in the folder where the `docker-compose.yaml` and `nats.conf` stored:
```bash
docker compose -f docker-compose.yaml -p superstream up
```
