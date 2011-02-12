/**********************************************************\
Original Author: Richard Bateman (taxilian)

Created:    Dec 3, 2009
License:    Dual license model; choose one of two:
            New BSD License
            http://www.opensource.org/licenses/bsd-license.php
            - or -
            GNU Lesser General Public License, version 2.1
            http://www.gnu.org/licenses/lgpl-2.1.html

Copyright 2009 PacketPass, Inc and the Firebreath development team
\**********************************************************/

#include <stdio.h>
#include <stdlib.h>

#include <dlfcn.h>

#include "NpapiBrowserHost.h"
#include "PluginCore.h"
#include "global/config.h"

#if FBMAC_USE_COREANIMATION
#include <QuartzCore/CoreAnimation.h>
#endif

#include "FactoryBase.h"

#include "NpapiPluginFactory.h"
#include <boost/make_shared.hpp>
#include <string>

#include "Mac/NpapiPluginMac.h"

using namespace FB::Npapi;

FB::Npapi::NpapiPluginPtr FB::Npapi::createNpapiPlugin(const FB::Npapi::NpapiBrowserHostPtr& host, const std::string& mimetype)
{
    return boost::make_shared<NpapiPluginMac>(host, mimetype);
}

namespace 
{
    std::string getPluginPath() 
    {
        ::Dl_info dlinfo; 
        if (::dladdr((void*)::NP_Initialize, &dlinfo) != 0) { 
            return dlinfo.dli_fname; 
        } else {
            return "";
        }
    }
}

NpapiPluginMac::NpapiPluginMac(const FB::Npapi::NpapiBrowserHostPtr &host, const std::string& mimetype)
	: NpapiPlugin(host, mimetype), m_eventModel((NPEventModel)-1), m_drawingModel((NPDrawingModel)-1)
#if FBMAC_USE_COREANIMATION
	, m_layer(NULL)
#endif
{
    // If you receive a BAD_ACCESS error here you probably have something
    // wrong in your FactoryMain.cpp in your plugin project's folder

    PluginCore::setPlatform("Mac", "NPAPI");
    
    // Get the path to the bundle
    static const std::string pluginPath = getPluginPath();      
    setFSPath(pluginPath);
	// These HAVE to be called here during the NPP_New call to set the drawing and event models.
	m_drawingModel = PluginWindowMac::initPluginWindowMac(m_npHost);
	m_eventModel = PluginEventMac::initPluginEventMac(m_npHost, m_drawingModel);

	// We can create our event model handler now.
	pluginEvt = PluginEventMacPtr(PluginEventMac::createPluginEventMac(m_eventModel));
    }
}

#if FBMAC_USE_COREANIMATION
	if (m_layer) {
		[(CALayer*)m_layer autorelease];
		m_layer = NULL;
    if(win != NULL) {
    }
#endif
NPError NpapiPluginMac::SetWindow(NPWindow* window) {
	NPError res = NPERR_NO_ERROR;
	if (window)
		if (!pluginWin)
			// If we don't have a PluginWindow, create one. It will be made for the chosen drawing model.
			pluginWin = PluginWindowMacPtr(PluginWindowMac::createPluginWindowMac(m_drawingModel));
			if (pluginWin)
				pluginWin->setNpHost(m_npHost);
				// Tell the event model which window to use for events.
				if (pluginEvt)
					pluginEvt->setPluginWindow(pluginWin);
            win->setWindowClipping(window->clipRect.top,    window->clipRect.left,
		if (pluginWin)
#if FBMAC_USE_COREANIMATION
			// Patch up the NPWindow before calling SetWindow for CoreAnimation to pass the CALayer.
			if ((PluginWindowMac::DrawingModelCoreAnimation == pluginWin->getDrawingModel()) || (PluginWindowMac::DrawingModelInvalidatingCoreAnimation == pluginWin->getDrawingModel()))
			{
				assert(!window->window);
				window->window = m_layer;
    else if (pluginWin != NULL) 
			// Set the Window.
			res = pluginWin->SetWindow(window);
#if FBMAC_USE_COREANIMATION
			if ((PluginWindowMac::DrawingModelCoreAnimation == pluginWin->getDrawingModel()) || (PluginWindowMac::DrawingModelInvalidatingCoreAnimation == pluginWin->getDrawingModel()))
				window->window = NULL;
    {
			// Notify the PluginCore about our new window. This will post an AttachedEvent.
			if (!pluginMain->GetWindow())
				pluginMain->SetWindow(pluginWin.get());
        // If the handle goes to NULL, our window is gone and we need to stop using it
            // Make a new plugin window object for FireBreath & our plugin.
		// Notify the PluginCore about our missing window. This will post an DetachedEvent.
		pluginWin.reset();
    return res;
    } else if (pluginWin != NULL) {
#if !FBMAC_USE_COCOA
    return 0;
	if (pluginEvt)
		return pluginEvt->HandleEvent(event);
}

int16_t NpapiPluginMac::HandleEvent(void* event)
	int16_t res = NPERR_GENERIC_ERROR;
	switch (variable) {
{
		case NPPVpluginCoreAnimationLayer:
		{
			// The BrowserPlugin owns the CALayer.
			if (!m_layer) m_layer = [[CALayer layer] retain];
			*(CALayer**) value = [(CALayer*)m_layer retain];
			res = NPERR_NO_ERROR;
		}	break;
		case NPPVpluginScriptableNPObject:
		{
			res = NpapiPlugin::GetValue(variable, value);
			if (NPERR_NO_ERROR == res)
				setReady(); // Ready state means that we are ready to interact with Javascript;
		}	break;
		default:
			res = NpapiPlugin::GetValue(variable, value);
			break;
                *((CALayer **)value) = (CALayer*)win->getLayer();
                [(CALayer *)win->getLayer() retain];
                return NPERR_NO_ERROR;
void NpapiPluginMac::HandleTimerEvent() {
	if (pluginWin)
		return pluginWin->handleTimerEvent();
    int16_t res = NpapiPlugin::GetValue(variable, value);
    if (res == NPERR_NO_ERROR && variable == NPPVpluginScriptableNPObject) {
        // Ready state means that we are ready to interact with Javascript;
        setReady();
    }
    return res;
}

void NpapiPluginMac::HandleCocoaTimerEvent() {
#if !FBMAC_USE_COCOA
    return;
#else
    PluginWindowMacCocoa* win = static_cast<PluginWindowMacCocoa*>(pluginWin);
    return win->handleTimerEvent();
#endif
}
