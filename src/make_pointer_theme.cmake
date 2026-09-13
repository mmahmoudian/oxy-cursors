if(NOT DEFINED output)
    message(FATAL_ERROR "output not defined")
endif()

if(NOT DEFINED inherits)
    message(FATAL_ERROR "inherits not defined")
endif()

file(WRITE ${output} "[Icon Theme]\nInherits=${inherits}\n")
