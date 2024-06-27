# az-tf-sensatech
[![Terraform](https://github.com/Tommi-Sensa/az-tf-sensatech/actions/workflows/azure-functions-app-container.yml/badge.svg?branch=main)](https://github.com/Tommi-Sensa/az-tf-sensatech/actions/workflows/azure-functions-app-container.yml)


Test to use terraform for sensatech azure management



### Terraform flow

```mermaid
graph TD;
    modules-->DSC_Test.tf;
    modules-->rg-terraform-stg.tf;
    modules-->DigiCertTest.tf;
    DSC_Test.tf-->tfstate.tf;
    rg-terraform-stg.tf-->tfstate.tf;
    DigiCertTest.tf-->tfstate.tf;
    tfstate.tf-->Azure;
```



### Azure Europe North

```geojson
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "id": 1,
      "properties": {
        "ID": 0
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
              [-21.82774,64.128288],
              [-9,54]
          ]
        ]
      }
    }
  ]
}
```
