#include "httpsignal.h"

Q_INVOKABLE void HttpSignal::fetch(QString url) {
    if (!manager) {
        manager = new QNetworkAccessManager(this);
    }
    QUrl qurl(url);
    if (!qurl.isValid() || qurl.isRelative()) {
        qurl = QUrl("http://localhost:3000").resolved(qurl);
    }

    if (!qurl.isValid()) {
        Q_EMIT error("Invalid URL" + qurl.toString(), qurl.toString());
        return;
    }

    QNetworkRequest request{qurl};

    QNetworkReply *reply = nullptr;
    reply = manager->get(request);
    QObject::connect(
        reply, &QNetworkReply::finished, this,
        [qurl, reply, this]() {
            QByteArray response = reply->readAll();
            if (reply->error() == QNetworkReply::NoError) {
                Q_EMIT then(QString::fromUtf8(response), qurl.toString());
            } else {
                Q_EMIT error(reply->errorString(), qurl.toString());
            }
            reply->deleteLater();
        },
        Qt::SingleShotConnection);
}
