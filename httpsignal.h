#pragma once

#include <qnetworkaccessmanager.h>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <qobject.h>
#include <QObject>
#include <qtmetamacros.h>
#include <qurl.h>

struct HttpSignal : public QObject {
    
    Q_OBJECT

    static inline QNetworkAccessManager* manager{};

public:
    Q_INVOKABLE void fetch(QString url);

Q_SIGNALS:
    void then(QString result,QString url);
    void error(QString error,QString url);
};
