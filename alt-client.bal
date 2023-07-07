import ballerina/io;
import ballerina/http;

configurable string clientId = "FlfJYKBD2c925h4lkycqNZlC2l4a";
configurable string clientSecret = "PJz0UhTJMrHOo68QQNpvnqAY_3Aa";

http:OAuth2ClientCredentialsGrantConfig config = {
    tokenUrl: "https://localhost:9445/oauth2/token",
    clientId: clientId,
    clientSecret: clientSecret,
    scopes: "admin",
    clientConfig: {
        secureSocket: {
            key: {
                path: "resources/client-keystore.p12",
                password: "password"
            },
            cert: {
                path: "resources/client-truststore.p12",
                password: "password"
            }
        }
    }
};

public function main() returns error? {
    http:ClientOAuth2Handler handler = new (config);
    map<string|string[]> headers = check handler.enrichHeaders({});
    io:println(headers);

    http:Client c = check new ("localhost:9090",
        secureSocket = {
            key: {
                path: "resources/client-keystore.p12",
                password: "password"
            },
            cert: {
                path: "resources/client-truststore.p12",
                password: "password"
            }
        }
    );
    
    json response = check c->/albums(headers);
    io:println(response);
}
