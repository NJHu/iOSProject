在iOS中使用RSA加密解密，需要用到.der和.p12后缀格式的文件，其中.der格式的文件存放的是公钥（Public key）用于加密，.p12格式的文件存放的是私钥（Private key）用于解密. 首先需要先生成这些文件，然后再将文件导入工程使用:

一、使用openssl生成所需秘钥文件
生成环境是在mac系统下，使用openssl进行生成，首先打开终端，按下面这些步骤依次来做：
1. 生成模长为1024bit的私钥文件private_key.pem
    openssl genrsa -out private_key.pem 1024

2. 生成证书请求文件rsaCertReq.csr
    openssl req -new -key private_key.pem -out rsaCerReq.csr
    注意：这一步会提示输入国家、省份、mail等信息，可以根据实际情况填写，或者全部不用填写，直接全部敲回车.

3. 生成证书rsaCert.crt，并设置有效时间为1年
    openssl x509 -req -days 3650 -in rsaCerReq.csr -signkey private_key.pem -out rsaCert.crt

4. 生成供iOS使用的公钥文件public_key.der
    openssl x509 -outform der -in rsaCert.crt -out public_key.der

5. 生成供iOS使用的私钥文件private_key.p12
    openssl pkcs12 -export -out private_key.p12 -inkey private_key.pem -in rsaCert.crt
    注意：这一步会提示给私钥文件设置密码，直接输入想要设置密码即可，然后敲回车，然后再验证刚才设置的密码，再次输入密码，然后敲回车，完毕！
    在解密时，private_key.p12文件需要和这里设置的密码配合使用，因此需要牢记此密码.

6. 生成供Java使用的公钥rsa_public_key.pem
    openssl rsa -in private_key.pem -out rsa_public_key.pem -pubout
7. 生成供Java使用的私钥pkcs8_private_key.pem
    openssl pkcs8 -topk8 -in private_key.pem -out pkcs8_private_key.pem -nocrypt



1, 生成private_key.pem
2, rsaCerReq.csr 证书请求文件, 公司信息
3,  生成证书rsaCert.crt, 有限期一年

4, ios公public_key.der
5, ios私钥private_key.p12     密码: 123456

6, java公钥rsa_public_key.pem
7, java私钥pkcs8_private_key.pem

备注: java的公钥, 私钥可以直接用

java公钥
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCtCIVirh1kpxpsi9NtuICAinBu
y5GaIf/MPNlwAY3BQN3og3XERBPfnd4tJRbN0bzyg+lVh7qJUaCAshniQtQp1P3R
b0TFWSLYc3BeF17fOUv0eco89gUBG82U6AiyrLRcrswLPsH4qWgWCLgAKO8L2SAk
XHhSX+am/snr4XPqDwIDAQAB
-----END PUBLIC KEY-----


java私钥
-----BEGIN PRIVATE KEY-----
MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAK0IhWKuHWSnGmyL
0224gICKcG7LkZoh/8w82XABjcFA3eiDdcREE9+d3i0lFs3RvPKD6VWHuolRoICy
GeJC1CnU/dFvRMVZIthzcF4XXt85S/R5yjz2BQEbzZToCLKstFyuzAs+wfipaBYI
uAAo7wvZICRceFJf5qb+yevhc+oPAgMBAAECgYEAlUrR0zeJEsv+x4LJFFTpQn6v
zViEsuj8zFn//VzJ0uDF1hR+qq1WPEz4YhkrGMAK92+LBgnKjypHgmKoZIjmhhoW
slHwub3nXfpBp+KamLxoe0VWnEUZYtpFnBgyOUfDHUkRg1OEkVMW39QEUMZnXqnV
NZ6iBQZAo9Y3J6s2GnECQQDT0m9oSE8QpfG5SlCU8a6J/jO0LFoivMi716FzHNm9
Rp1tNeIzTwoIt3r7T1TTNZj2ckPK9x4jMRM1ugBUs4kpAkEA0R8VsWe3gY80ufEp
1gbWo9Nro9/zfxRDrTx9gY9sbrRtmrMcbmwWZKNRdwzARnP0EF2OHd5JzL1tZgRa
bGLodwJARs46BV7eZw9BfRGVXCRplqENgXWt75yxcPEEe+kx864uI3p2kXYjQYSr
rGP5U9y/s+nANZFjVpop9LSnNakJ+QJBAJsJK6EBnreLvvBXjceh/EEqvfOZVcGR
+XaWkQmbli0g0N1PCrYGpjdoKT5UkrvovTng0jrskNQcX92xPoR6c5MCQGSUoZWk
j1GZFm0GOm3L4SzkHEfMqqRjU3+Y0TgW8CGijLUQH6TsZzoHpWELwG6EZbGohGAH
4v9yhn+nuHaSD0I=
-----END PRIVATE KEY-----
