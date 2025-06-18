#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H
#include <QObject>
#include <qjsvalue.h>
class HttpPromise;
class QNetworkAccessManager;

class HttpClient : public QObject {
    Q_OBJECT
public:
    explicit HttpClient(QObject *parent = nullptr);
    ~HttpClient() override;
    Q_INVOKABLE HttpPromise *fetch(QString const &url);

private:
    QNetworkAccessManager *manager_{};
};

#endif // HTTPCLIENT_H
