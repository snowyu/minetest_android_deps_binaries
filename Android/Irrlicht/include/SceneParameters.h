// Copyright (C) 2002-2012 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

#ifndef __I_SCENE_PARAMETERS_H_INCLUDED__
#define __I_SCENE_PARAMETERS_H_INCLUDED__

#include "irrTypes.h"

/*! \file SceneParameters.h
	\brief Header file containing all scene parameters for modifying mesh loading etc.

	This file includes all parameter names which can be set using ISceneManager::getParameters()
	to modify the behavior of plugins and mesh loaders.
*/

namespace irr
{
namespace scene
{
	//! Name of the parameter for changing how Irrlicht handles the ZWrite flag for transparent (blending) materials
	/** The default behavior in Irrlicht is to disable writing to the
	z-buffer for all really transparent, i.e. blending materials. This
	avoids problems with intersecting faces, but can also break renderings.
	If transparent materials should use the SMaterial flag for ZWriteEnable
	just as other material types use this attribute.
	Use it like this:
	\code
	SceneManager->getParameters()->setAttribute(scene::ALLOW_ZWRITE_ON_TRANSPARENT, true);
	\endcode
	**/
	const c8* const ALLOW_ZWRITE_ON_TRANSPARENT = "Allow_ZWrite_On_Transparent";

	//! Flag to avoid loading group structures in .obj files
	/** Use it like this:
	\code
	SceneManager->getParameters()->setAttribute(scene::OBJ_LOADER_IGNORE_GROUPS, true);
	\endcode
	**/
	const c8* const OBJ_LOADER_IGNORE_GROUPS = "OBJ_IgnoreGroups";


	//! Flag to avoid loading material .mtl file for .obj files
	/** Use it like this:
	\code
	SceneManager->getParameters()->setAttribute(scene::OBJ_LOADER_IGNORE_MATERIAL_FILES, true);
	\endcode
	**/
	const c8* const OBJ_LOADER_IGNORE_MATERIAL_FILES = "OBJ_IgnoreMaterialFiles";


	//! Flag to ignore the b3d file's mipmapping flag
	/** Instead Irrlicht's texture creation flag is used. Use it like this:
	\code
	SceneManager->getParameters()->setAttribute(scene::B3D_LOADER_IGNORE_MIPMAP_FLAG, true);
	\endcode
	**/
	const c8* const B3D_LOADER_IGNORE_MIPMAP_FLAG = "B3D_IgnoreMipmapFlag";

	//! Name of the parameter for setting the length of debug normals.
	/** Use it like this:
	\code
	SceneManager->getParameters()->setAttribute(scene::DEBUG_NORMAL_LENGTH, 1.5f);
	\endcode
	**/
	const c8* const DEBUG_NORMAL_LENGTH = "DEBUG_Normal_Length";

	//! Name of the parameter for setting the color of debug normals.
	/** Use it like this:
	\code
	SceneManager->getParameters()->setAttributeAsColor(scene::DEBUG_NORMAL_COLOR, video::SColor(255, 255, 255, 255));
	\endcode
	**/
	const c8* const DEBUG_NORMAL_COLOR = "DEBUG_Normal_Color";


} // end namespace scene
} // end namespace irr

#endif

