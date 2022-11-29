#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QObject>
#include <QObject>
#include <QVariantList>
#include <QNetworkAccessManager>
#include <QXmlStreamReader>
#include <QNetworkReply>
#include <QAuthenticator>

class Downloader : public QObject
{
    Q_OBJECT

private:
    QNetworkAccessManager manager;
    std::shared_ptr<QNetworkRequest> _request;
    int _authoriation_attempt;
public:
    explicit Downloader(QObject *parent = nullptr);
    Q_INVOKABLE void get(QString url,QString identity);
    Q_INVOKABLE void post(QString url,QString identity,QString json);
signals:
    /**
     * @brief Расписание загружено
     */
    void loaded(QByteArray parameter);

    /**
     * @brief Ошибка соединения
     */
    void connection_error();

    /**
     * @brief Ошибка авторизации
     */
    void authorization_error();
public slots:

    /**
     * @brief Окончание загрузки
     */
    void downloadScheduleFinished(QNetworkReply *reply);

    /**
     * @brief Ввод логина/пароля
     */
    void authenticationRequired (QNetworkReply*, QAuthenticator*);

    /**
     * @brief Ошибка авторизации
     */
    void sslErrors(QNetworkReply *reply, const QList<QSslError> &errors);

};

#endif // DOWNLOADER_H
