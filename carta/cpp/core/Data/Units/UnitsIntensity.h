/***
 * List of available intensity units.
 *
 */

#pragma once

#include "State/ObjectManager.h"
#include "State/StateInterface.h"
#include "CartaLib/ProfileInfo.h"
#include <QStringList>

namespace Carta {

namespace Data {

class UnitsIntensity : public Carta::State::CartaObject {

public:

    /**
     * Returns the default intensity unit.
     * @return the default intensity unit.
     */
    QString getDefault() const;

    /**
     * Translates a possible case insensitive unit string into one
     * that matches the actual units exactly.
     * @param unitStr - an identifier for intensity units that may not match
     *      in case.
     * @return - the actual intensity units or an empty string if the units are
     *      not recognized.
     */
    QString getActualUnits( const QString& unitStr ) const;

    /**
     * Intensity units depend on how profile points are aggregate; reset
     * the available intensity units based on the aggregation method.
     * @param stat - the method used to aggregate profile points.
     */
    void resetUnits( Carta::Lib::ProfileInfo::AggregateType stat );

    const static QString CLASS_NAME;
    const static QString UNIT_LIST;

    virtual ~UnitsIntensity();

private:

    const static QString NAME_PEAK;
    const static QString NAME_JYBEAM;
    const static QString NAME_JYSR;
    const static QString NAME_JYARCSEC;
    const static QString NAME_JY;
    const static QString NAME_KELVIN;

    QString m_defaultUnit;

    void _initializeDefaultState();
    void _initUnit( int * index, const QString& name);

    static bool m_registered;
    UnitsIntensity( const QString& path, const QString& id );
    class Factory;

	UnitsIntensity( const UnitsIntensity& other);
	UnitsIntensity& operator=( const UnitsIntensity& other );
};
}
}
