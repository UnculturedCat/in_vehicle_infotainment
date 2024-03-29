#ifndef MAPSCONTROLLER_H
#define MAPSCONTROLLER_H

#include <QObject>
#include <QGeoServiceProvider>
#include <QPlaceSearchRequest>
#include <QGeoPositionInfoSource>
#include <QPlaceSearchReply>
#include <QPlaceResult>

class MapsController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString searchTerm READ searchTerm WRITE setSearchTerm NOTIFY searchTermChanged FINAL)
    Q_PROPERTY(double_t mapZoomLevel READ mapZoomLevel WRITE setMapZoomLevel NOTIFY mapZoomLevelChanged FINAL)
    Q_PROPERTY(QGeoCoordinate deviceLocation READ deviceLocation WRITE setDeviceLocation NOTIFY deviceLocationChanged FINAL)
    Q_PROPERTY(QGeoPositionInfoSource* positionSource READ positionSource  NOTIFY positionSourceChanged FINAL)

public:
    explicit MapsController(QObject *parent = nullptr);
    QString searchTerm () const;
    double_t mapZoomLevel () const;
    QGeoCoordinate deviceLocation() const;

    QGeoPositionInfoSource* positionSource() const;

    bool centerOnFirstSearchResult() const;
    const QList<QPlace>& placeSearchResults() const;
    Q_INVOKABLE void setCenterOnResult(const bool);

signals:
    void searchTermChanged();
    void mapZoomLevelChanged();
    void placeResultsHandled();
    void deviceLocationChanged();
    void positionSourceChanged();

public slots:
    void setSearchTerm(const QString&);
    void setMapZoomLevel(const double_t&);
    void searchForPlace(const QString&);
    void setDeviceLocation(const QGeoCoordinate&);
   // void setPositionSource(const QGeoPositionInfoSource*);

private:
    QString m_search_term;
    double_t m_map_zoom_level;
    QSharedPointer<QGeoServiceProvider> m_geo_service_provider;
    QSharedPointer<QPlaceManager> m_place_manager;
   // QSharedPointer<QPlaceSearchRequest> m_search_request;
    QSharedPointer<QGeoPositionInfoSource> m_position_source;
    QSharedPointer<QPlaceSearchReply> m_search_reply;
    QGeoCoordinate m_device_location;
    QList<QPlace> m_place_search_result;

    bool m_center_on_first_search_result;

    void initializeProvider();
    void initializePositionSource();
    bool providerError();


private slots:
    void handlePlaceSearchReply();
    void handlePositionUpdated(const QGeoPositionInfo&);

};

#endif // MAPSCONTROLLER_H
