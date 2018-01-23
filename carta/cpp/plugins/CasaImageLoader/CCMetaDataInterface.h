/**
 *
 **/

#pragma once

#include "CartaLib/IImage.h"
#include <casacore/coordinates/Coordinates/CoordinateSystem.h>
#include <memory>


class CCMetaDataInterface
        : public Carta::Lib::Image::MetaDataInterface
{
    CLASS_BOILERPLATE( CCMetaDataInterface);

public:
    CCMetaDataInterface(QString htmlTitle, std::shared_ptr<casa::CoordinateSystem> casaCS);

    virtual Carta::Lib::Image::MetaDataInterface *
    clone() override;

    virtual CoordinateFormatterInterface::SharedPtr
    coordinateFormatter() override;

//    virtual CoordinateGridPlotterInterface::SharedPtr
//    coordinateGridPlotter() override;

    virtual PlotLabelGeneratorInterface::SharedPtr
    plotLabelGenerator() override;

    virtual QString
    title( TextFormat format ) override;

    virtual QStringList
    otherInfo( TextFormat format ) override;

    //Return the casacore coordinate system.
    //Needed to parse CASA regions of an image.
    std::shared_ptr<casa::CoordinateSystem> getCoordinateSystem() const;

protected:
    Carta::Lib::HtmlString m_title;
    std::shared_ptr<casa::CoordinateSystem> m_casaCS;

};
