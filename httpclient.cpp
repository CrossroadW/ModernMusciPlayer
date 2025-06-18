#include "httpclient.h"
#include "httppromise.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <qjsvalue.h>
#include <qlogging.h>
#include <qnamespace.h>
#include <QNetworkAccessManager>
#include <qnetworkreply.h>
#include <QNetworkReply>
#include <qobject.h>
#include <qurl.h>

HttpClient::HttpClient(QObject *parent) : QObject(parent) {}

HttpClient::~HttpClient() {
    qDebug() << "~HttpClient";
}

HttpPromise *HttpClient::fetch(QString const &url) {
    if (!manager_) {
        manager_ = (new QNetworkAccessManager(this));
    }
    HttpPromise *promise = new HttpPromise(this);
    QUrl qurl(url);

    if (!qurl.isValid() || qurl.isRelative()) {
        qurl = QUrl("http://localhost:3000").resolved(qurl);
    }

    if (!qurl.isValid()) {
        Q_EMIT promise->error("Invalid URL", qurl.toString());
        return promise;
    }

    QNetworkRequest request{qurl};
    QNetworkReply *reply = nullptr;
    reply = manager_->get(request);

    QObject::connect(
        reply, &QNetworkReply::finished, this,
        [qurl, reply, promise]() {
            QByteArray response = reply->readAll();
            if (reply->error() == QNetworkReply::NoError) {
                Q_EMIT promise->success(QString::fromUtf8(response),
                                        qurl.toString());
            } else {
                Q_EMIT promise->error(reply->errorString(), qurl.toString());
            }
            reply->deleteLater();
        },
        Qt::SingleShotConnection);

    return promise;
}
