macro(add_cursor cursor color theme dpi)
    add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/oxy-${theme}/svg/${cursor}.svg
                       DEPENDS ${MAKE_SVG} ${CMAKE_CURRENT_SOURCE_DIR}/colors.in ${SVGDIR}/${cursor}.svg
                       COMMAND ${CMAKE_COMMAND} -Dconfig=${CMAKE_CURRENT_SOURCE_DIR}/colors.in
                                                -Dinput=${SVGDIR}/${cursor}.svg
                                                -Doutput=${CMAKE_BINARY_DIR}/oxy-${theme}/svg/${cursor}.svg
                                                -P ${MAKE_SVG}
                      )
    add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/oxy-${theme}/png/${cursor}.png
                       DEPENDS ${CMAKE_BINARY_DIR}/oxy-${theme}/svg/${cursor}.svg
                       COMMAND ${CONVERT} -background none
                                          -density ${dpi}
                                          ${CMAKE_BINARY_DIR}/oxy-${theme}/svg/${cursor}.svg
                                          ${CMAKE_BINARY_DIR}/oxy-${theme}/png/${cursor}.png
                      )
endmacro(add_cursor)

macro(add_x_cursor theme cursor dpi)
    set(inputs)
    foreach(png ${${cursor}_inputs})
        list(APPEND inputs ${CMAKE_BINARY_DIR}/oxy-${theme}/png/${png})
    endforeach(png)
    add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/oxy-${theme}/config/${cursor}.in
                       DEPENDS ${MAKE_CONFIG} ${CONFIGDIR}/${cursor}.in
                       COMMAND ${CMAKE_COMMAND} -Dconfig=${CONFIGDIR}/${cursor}.in
                                                -Doutput=${CMAKE_BINARY_DIR}/oxy-${theme}/config/${cursor}.in
                                                -Ddpi=${dpi}
                                                -P ${MAKE_CONFIG}
                      )
    add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/oxy-${theme}/cursors/${cursor}
                       DEPENDS ${inputs} ${CMAKE_BINARY_DIR}/oxy-${theme}/config/${cursor}.in
                       COMMAND ${XCURSORGEN} -p ${CMAKE_BINARY_DIR}/oxy-${theme}/png
                                             ${CMAKE_BINARY_DIR}/oxy-${theme}/config/${cursor}.in
                                             ${CMAKE_BINARY_DIR}/oxy-${theme}/cursors/${cursor}
                      )
endmacro(add_x_cursor)

set(THUMBNAIL_CURSORS
    left_ptr
    hand
    xterm
    help
    fleur
    grab_open
    cross
    link
    forbidden
    up_arrow
    size_diag-tl2br
    split_h
   )
set(THUMBNAIL_TILE_SIZE 128)
set(THUMBNAIL_TILE_PADDED 144)
set(THUMBNAIL_TILE_MARGIN 12)
set(THUMBNAIL_COLUMNS 6)
set(THUMBNAIL_ROWS 2)
set(THUMBNAIL_TITLE_HEIGHT 100)
set(THUMBNAIL_BACKGROUND "gray17")
set(THUMBNAIL_FONT "DejaVu-Sans-Bold")

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/packages)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/thumbnails)
macro(add_thumbnail color theme dpi)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-svg)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-png)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-tile)
    set(${theme}_thumb_tiles)
    foreach(cursor ${THUMBNAIL_CURSORS})
        add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-svg/${cursor}.svg
                           DEPENDS ${MAKE_SVG} ${CMAKE_CURRENT_SOURCE_DIR}/colors.in ${SVGDIR}/${cursor}.svg
                           COMMAND ${CMAKE_COMMAND} -Dconfig=${CMAKE_CURRENT_SOURCE_DIR}/colors.in
                                                    -Dinput=${SVGDIR}/${cursor}.svg
                                                    -Doutput=${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-svg/${cursor}.svg
                                                    -P ${MAKE_SVG}
                          )
        add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-png/${cursor}.png
                           DEPENDS ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-svg/${cursor}.svg
                           COMMAND ${CONVERT} -background none
                                              -density ${dpi}
                                              ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-svg/${cursor}.svg
                                              ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-png/${cursor}.png
                          )
        add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-tile/${cursor}.png
                           DEPENDS ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-png/${cursor}.png
                           COMMAND ${CONVERT} ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-png/${cursor}.png
                                              -background none -gravity center
                                              -resize ${THUMBNAIL_TILE_SIZE}x${THUMBNAIL_TILE_SIZE}
                                              -extent ${THUMBNAIL_TILE_PADDED}x${THUMBNAIL_TILE_PADDED}
                                              ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-tile/${cursor}.png
                          )
        list(APPEND ${theme}_thumb_tiles ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-tile/${cursor}.png)
    endforeach(cursor)

    math(EXPR thumbnail_width "${THUMBNAIL_COLUMNS} * ${THUMBNAIL_TILE_PADDED}")

    add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-title.png
                       DEPENDS ${${theme}_thumb_tiles}
                       COMMAND ${CONVERT} -size ${thumbnail_width}x${THUMBNAIL_TITLE_HEIGHT}
                                          xc:${THUMBNAIL_BACKGROUND}
                                          -gravity center -fill white -pointsize 36
                                          -font ${THUMBNAIL_FONT}
                                          -annotate 0 "Oxy Cursors - ${theme} theme"
                                          ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-title.png
                      )

    add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-collage.png
                       DEPENDS ${${theme}_thumb_tiles}
                       COMMAND ${MONTAGE} ${${theme}_thumb_tiles}
                                          -tile ${THUMBNAIL_COLUMNS}x${THUMBNAIL_ROWS}
                                          -geometry ${THUMBNAIL_TILE_PADDED}x${THUMBNAIL_TILE_PADDED}+${THUMBNAIL_TILE_MARGIN}+${THUMBNAIL_TILE_MARGIN}
                                          -background ${THUMBNAIL_BACKGROUND}
                                          ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-collage.png
                      )

    add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/thumbnails/oxy-${theme}.png
                       DEPENDS ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-title.png
                               ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-collage.png
                       COMMAND ${CONVERT} ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-title.png
                                          ${CMAKE_BINARY_DIR}/oxy-${theme}/thumb-collage.png
                                          -background ${THUMBNAIL_BACKGROUND} -append
                                          ${CMAKE_BINARY_DIR}/thumbnails/oxy-${theme}.png
                      )
    add_custom_target(thumbnail-${theme} ALL DEPENDS ${CMAKE_BINARY_DIR}/thumbnails/oxy-${theme}.png)
endmacro(add_thumbnail)

macro(add_theme color theme dpi)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/oxy-${theme}/png)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/oxy-${theme}/svg)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/oxy-${theme}/config)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/oxy-${theme}/cursors)
    set(${theme}_cursors)
    foreach(svg ${SVGS})
        string(REGEX REPLACE ".*/" "" cursor ${svg})
        string(REGEX REPLACE "[.]svg" "" cursor ${cursor})
        add_cursor(${cursor} ${color} ${theme} ${dpi})
    endforeach(svg)
    foreach(cursor ${CURSORS})
        add_x_cursor(${theme} ${cursor} ${dpi})
        list(APPEND ${theme}_cursors ${CMAKE_BINARY_DIR}/oxy-${theme}/cursors/${cursor})
    endforeach(cursor)
    add_custom_target(theme-${theme} ALL DEPENDS ${${theme}_cursors})
    add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/oxy-${theme}/index.theme
                       DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/index.theme
                       COMMAND ${CMAKE_COMMAND} -E copy_if_different
                                                   ${CMAKE_CURRENT_SOURCE_DIR}/index.theme
                                                   ${CMAKE_BINARY_DIR}/oxy-${theme}/index.theme
                      )
    set(package_staging_dir ${CMAKE_BINARY_DIR}/package-staging/oxy-${theme})
    add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/packages/oxy-${theme}.tar.bz2
                       DEPENDS ${${theme}_cursors} ${CMAKE_BINARY_DIR}/oxy-${theme}/index.theme ${MAKE_POINTER_THEME}
                       COMMAND ${CMAKE_COMMAND} -E rm -rf ${package_staging_dir}
                       COMMAND ${CMAKE_COMMAND} -E make_directory ${package_staging_dir}/oxy-${theme}
                       COMMAND ${CMAKE_COMMAND} -E copy_directory
                                                 ${CMAKE_BINARY_DIR}/oxy-${theme}/cursors
                                                 ${package_staging_dir}/oxy-${theme}/cursors
                       COMMAND ${CMAKE_COMMAND} -E copy_if_different
                                                 ${CMAKE_BINARY_DIR}/oxy-${theme}/index.theme
                                                 ${package_staging_dir}/oxy-${theme}/index.theme
                       COMMAND ${CMAKE_COMMAND} -E make_directory ${package_staging_dir}/default
                       COMMAND ${CMAKE_COMMAND} -Doutput=${package_staging_dir}/default/index.theme
                                                -Dinherits=oxy-${theme}
                                                -P ${MAKE_POINTER_THEME}
                       COMMAND ${TAR} cjf ${CMAKE_BINARY_DIR}/packages/oxy-${theme}.tar.bz2
                                      -C ${package_staging_dir}
                                      oxy-${theme}
                                      default
                       WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                      )
    add_custom_target(package-${theme} DEPENDS ${CMAKE_BINARY_DIR}/packages/oxy-${theme}.tar.bz2)
endmacro(add_theme)
