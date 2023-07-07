import ballerina/io;
import ballerina/http;

configurable string clientId = "FlfJYKBD2c925h4lkycqNZlC2l4a";
configurable string clientSecret = "PJz0UhTJMrHOo68QQNpvnqAY_3Aa";

http:Client c = check new ("localhost:9090",
    auth = {
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
    },
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

public function main() returns error? {
    json response = check c->/albums;
    io:println(response);
}
