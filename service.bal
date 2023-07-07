import ballerina/log;
import ballerina/http;

type Album readonly & record {|
    string title;
    string artist;
|};

listener http:Listener securedEP = new (9090,
    secureSocket = {
        key: {
            path: "resources/service-keystore.p12",
            password: "password"
        },
        mutualSsl: {
            cert: {
                path: "resources/service-truststore.p12",
                password: "password"
            }
        },
        ciphers : ["ECDHE-RSA-AES256-GCM-SHA384"],
        protocol: {            
            name: http:TLS,
            versions: ["TLSv1.2"]
        }
    }
);

@http:ServiceConfig {
    auth: [
        {
            oauth2IntrospectionConfig: {
                url: "https://localhost:9445/oauth2/introspect",
                tokenTypeHint: "access_token",
                scopeKey: "scp",
                clientConfig: {
                    customHeaders: {"Authorization": "Basic YWRtaW46YWRtaW4="},
                    secureSocket: {
                        key: {
                            path: "resources/service-keystore.p12",
                            password: "password"
                        },
                        cert: {
                            path: "resources/service-truststore.p12",
                            password: "password"
                        }
                    }
                }
            },
            scopes: ["admin"]
        }
    ]
}
service / on securedEP {
    function init() {
        log:printInfo("Service secured by OAuth2 started.");
    }

    resource function get albums() returns Album[] {
        return [
            {title: "Blue Train", artist: "John Coltrane"},
            {title: "Jeru", artist: "Gerry Mulligan"}
        ];
    }
}
