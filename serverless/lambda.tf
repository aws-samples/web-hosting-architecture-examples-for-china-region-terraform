resource "aws_lambda_function" "RequestUnicorn" {
  function_name = "RequestUnicorn"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "tiange-s3-web-hosting"   
  s3_key = "unicorn-lambda-code/index.js.zip"   # need to change later

  # "main" is the filename within the zip file (index.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "index.handler"
  runtime = "nodejs12.x"
  memory_size = 128

  role = aws_iam_role.lambda-iam-role.arn
}

resource "aws_lambda_permission" "api-gateway-invoke-get-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.RequestUnicorn.arn
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_deployment.RequestUnicorn-api-gateway-deployment.execution_arn}/*/*"
}

