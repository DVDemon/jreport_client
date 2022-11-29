#include "downloader.h"
#include <QDebug>

Downloader::Downloader(QObject *parent) : QObject(parent)
{
    connect(&manager, SIGNAL(finished(QNetworkReply*)),
            SLOT(downloadScheduleFinished(QNetworkReply*)));

    connect(&manager,SIGNAL(authenticationRequired(QNetworkReply*, QAuthenticator*)),
            SLOT(authenticationRequired(QNetworkReply *, QAuthenticator *)));
}

void Downloader::downloadScheduleFinished(QNetworkReply *reply)
{
    if(reply->error()==QNetworkReply::NoError){
        emit loaded(reply->readAll());
    } else {
        if(reply->error()<6) emit connection_error();
        else emit authorization_error();
    }

}

void Downloader::sslErrors(QNetworkReply *, const QList<QSslError> &){
    emit authorization_error();
}

void Downloader::authenticationRequired(QNetworkReply *, QAuthenticator *auth)
{
     qDebug() << "dd authorization required";
    _authoriation_attempt++;
    if(_authoriation_attempt>3) {
        manager.clearAccessCache();
        emit authorization_error();
    }
    /*
    auth->setUser(Configuration::GetInstance().getName());
    auth->setPassword(Configuration::GetInstance().getPassword());
    auth->setRealm(Configuration::GetInstance().getRealm());*/
}

void Downloader::get(QString url,QString identity){
    _authoriation_attempt = 0;
    _request = std::shared_ptr<QNetworkRequest>(new QNetworkRequest(QUrl(url)));
    _request->setRawHeader("Authorization", identity.toUtf8());
    manager.get(*_request);
}

void Downloader::post(QString url,QString identity,QString json){
     QByteArray array = json.toUtf8();
    _authoriation_attempt = 0;
    _request = std::shared_ptr<QNetworkRequest>(new QNetworkRequest(QUrl(url)));
    _request->setRawHeader("Authorization", identity.toUtf8());
    manager.post(*_request,array);
}
