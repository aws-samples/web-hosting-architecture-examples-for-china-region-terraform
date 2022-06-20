resource "aws_api_gateway_rest_api" "RequestUnicorn-api-gateway" {
  name        = "RequestUnicornAPI"
  description = "API to access codingtips application"
  body        = "${data.template_file.RequestUnicorn.rendered}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}

data "template_file" RequestUnicorn{
  template = "${file("WildRydes.yaml")}"

  vars = {
    post_lambda_arn = "${aws_lambda_function.RequestUnicorn.invoke_arn}"
  }
}

resource "aws_api_gateway_deployment" "RequestUnicorn-api-gateway-deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.RequestUnicorn-api-gateway.id}"
  stage_name  = "default"
}
