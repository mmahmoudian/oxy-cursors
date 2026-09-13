file(GLOB SVGS svg/*.svg)
file(GLOB CONFIGS config/*.in)

set(SVGDIR ${CMAKE_SOURCE_DIR}/svg)
set(CONFIGDIR ${CMAKE_SOURCE_DIR}/config)
set(MAKE_CONFIG ${CMAKE_SOURCE_DIR}/make_config.cmake)
set(MAKE_SVG ${CMAKE_SOURCE_DIR}/make_svg.cmake)
set(MAKE_POINTER_THEME ${CMAKE_SOURCE_DIR}/make_pointer_theme.cmake)
