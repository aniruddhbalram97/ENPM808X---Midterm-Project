# x86/x86-64 arch:
# SSE / SSE2 (always available on 64-bit CPUs)
# SSE3 / SSSE3
# SSE4_1 / SSE4_2 / POPCNT
# AVX / AVX2 / AVX_512F
# FMA3
#
# AVX512 details: https://en.wikipedia.org/wiki/AVX-512#CPUs_with_AVX-512
#
# CPU features groups:
# AVX512_COMMON (Common instructions AVX-512F/CD for all CPUs that support AVX-512)
# AVX512_KNL (Knights Landing with AVX-512F/CD/ER/PF)
# AVX512_KNM (Knights Mill with AVX-512F/CD/ER/PF/4FMAPS/4VNNIW/VPOPCNTDQ)
# AVX512_SKX (Skylake-X with AVX-512F/CD/BW/DQ/VL)
# AVX512_CNL (Cannon Lake with AVX-512F/CD/BW/DQ/VL/IFMA/VBMI)
# AVX512_CLX (Cascade Lake with AVX-512F/CD/BW/DQ/VL/VNNI)
# AVX512_ICL (Ice Lake with AVX-512F/CD/BW/DQ/VL/IFMA/VBMI/VNNI/VBMI2/BITALG/VPOPCNTDQ/VPCLMULQDQ*/GFNI*/VAES*)

# ppc64le arch:
# VSX  (always available on Power8)
# VSX3 (always available on Power9)

# CPU_{opt}_SUPPORTED=ON/OFF - compiler support (possibly with additional flag)
# CPU_{opt}_IMPLIES=<list>
# CPU_{opt}_FORCE=<list> - subset of "implies" list
# CPU_{opt}_GROUP=<list> - similar to "implies" list, but additionally merges compiler flags
# CPU_{opt}_FLAGS_ON=""
# CPU_{opt}_FEATURE_ALIAS - mapping to CV_CPU_* HWFeature enum

# Input variables:
# CPU_BASELINE=<list> - preferred list of baseline optimizations
# CPU_DISPATCH=<list> - preferred list of dispatched optimizations

# Advanced input variables:
# CPU_BASELINE_REQUIRE=<list> - list of required baseline optimizations
# CPU_DISPATCH_REQUIRE=<list> - list of required dispatched optimizations
# CPU_BASELINE_DISABLE=<list> - list of disabled baseline optimizations

# Output variables:
# CPU_BASELINE_FINAL=<list> - final list of enabled compiler optimizations
# CPU_DISPATCH_FINAL=<list> - final list of dispatched optimizations
#
# CPU_DISPATCH_FLAGS_${opt} - flags for source files compiled separately (<name>.avx2.cpp)
#
# CPU_{opt}_ENABLED_DEFAULT=ON/OFF - has compiler support without additional flag (CPU_BASELINE_DETECT=ON only)

set(CPU_ALL_OPTIMIZATIONS "SSE;SSE2;SSE3;SSSE3;SSE4_1;SSE4_2;POPCNT;AVX;FP16;AVX2;FMA3;AVX_512F")
list(APPEND CPU_ALL_OPTIMIZATIONS "AVX512_COMMON;AVX512_KNL;AVX512_KNM;AVX512_SKX;AVX512_CNL;AVX512_CLX;AVX512_ICL")
list(APPEND CPU_ALL_OPTIMIZATIONS NEON VFPV3 FP16 NEON_DOTPROD)
list(APPEND CPU_ALL_OPTIMIZATIONS MSA)
list(APPEND CPU_ALL_OPTIMIZATIONS VSX VSX3)
list(APPEND CPU_ALL_OPTIMIZATIONS RVV)
list(APPEND CPU_ALL_OPTIMIZATIONS LASX)
list(REMOVE_DUPLICATES CPU_ALL_OPTIMIZATIONS)

ocv_update(CPU_VFPV3_FEATURE_ALIAS "")


set(HELP_CPU_BASELINE "Specify list of enabled baseline CPU optimizations")
set(HELP_CPU_BASELINE_REQUIRE "Specify list of required baseline CPU optimizations")
set(HELP_CPU_BASELINE_DISABLE "Specify list of forbidden baseline CPU optimizations")
set(HELP_CPU_DISPATCH "Specify list of dispatched CPU optimizations")
set(HELP_CPU_DISPATCH_REQUIRE "Specify list of required dispatched CPU optimizations")

foreach(var CPU_BASELINE CPU_BASELINE_REQUIRE CPU_BASELINE_DISABLE CPU_DISPATCH CPU_DISPATCH_REQUIRE)
  if(DEFINED ${var})
    string(REPLACE "," ";" _list "${${var}}")
    set(${var} "${_list}" CACHE STRING "${HELP_${var}}" FORCE)
  endif()
endforeach()

# process legacy flags
macro(ocv_optimization_process_obsolete_option legacy_flag OPT legacy_warn)
  if(DEFINED "${legacy_flag}")
    if("${legacy_warn}")
      message(STATUS "WARNING: Option ${legacy_flag}='${${legacy_flag}}' is deprecated and should not be used anymore")
      message(STATUS "         Behaviour of this option is not backward compatible")
      message(STATUS "         Refer to 'CPU_BASELINE'/'CPU_DISPATCH' CMake options documentation")
    endif()
    if("${${legacy_flag}}")
      if(NOT ";${CPU_BASELINE_REQUIRE};" MATCHES ";${OPT};")
        set(CPU_BASELINE_REQUIRE "${CPU_BASELINE_REQUIRE};${OPT}" CACHE STRING "${HELP_CPU_BASELINE_REQUIRE}" FORCE)
      endif()
    else()
      if(NOT ";${CPU_BASELINE_DISABLE};" MATCHES ";${OPT};")
        set(CPU_BASELINE_DISABLE "${CPU_BASELINE_DISABLE};${OPT}" CACHE STRING "${HELP_CPU_BASELINE_DISABLE}" FORCE)
      endif()
    endif()
  endif()
endmacro()
ocv_optimization_process_obsolete_option(ENABLE_SSE SSE ON)
ocv_optimization_process_obsolete_option(ENABLE_SSE2 SSE2 ON)
ocv_optimization_process_obsolete_option(ENABLE_SSE3 SSE3 ON)
ocv_optimization_process_obsolete_option(ENABLE_SSSE3 SSSE3 ON)
ocv_optimization_process_obsolete_option(ENABLE_SSE41 SSE4_1 ON)
ocv_optimization_process_obsolete_option(ENABLE_SSE42 SSE4_2 ON)
ocv_optimization_process_obsolete_option(ENABLE_POPCNT POPCNT ON)
ocv_optimization_process_obsolete_option(ENABLE_AVX AVX ON)
ocv_optimization_process_obsolete_option(ENABLE_AVX2 AVX2 ON)
ocv_optimization_process_obsolete_option(ENABLE_FMA3 FMA3 ON)

ocv_optimization_process_obsolete_option(ENABLE_VFPV3 VFPV3 OFF)
ocv_optimization_process_obsolete_option(ENABLE_NEON NEON OFF)

ocv_optimization_process_obsolete_option(ENABLE_VSX VSX ON)

ocv_optimization_process_obsolete_option(ENABLE_RVV RVV OFF)

macro(ocv_is_optimization_in_list resultvar check_opt)
  set(__checked "")
  set(__queue ${ARGN})
  set(${resultvar} 0)
  while(__queue AND NOT ${resultvar})
    list(REMOVE_DUPLICATES __queue)
    set(__queue_current ${__queue})
    set(__queue "")
    foreach(OPT ${__queue_current})
      if("x${OPT}" STREQUAL "x${check_opt}")
        set(${resultvar} 1)
        break()
      elseif(NOT ";${__checked};" MATCHES ";${OPT};")
        list(APPEND __queue ${CPU_${OPT}_IMPLIES})
      endif()
      list(APPEND __checked ${OPT})
    endforeach()
  endwhile()
endmacro()

macro(ocv_is_optimization_in_force_list resultvar check_opt)
  set(__checked "")
  set(__queue ${ARGN})
  set(${resultvar} 0)
  while(__queue AND NOT ${resultvar})
    list(REMOVE_DUPLICATES __queue)
    set(__queue_current ${__queue})
    set(__queue "")
    foreach(OPT ${__queue_current})
      if(OPT STREQUAL "${check_opt}")
        set(${resultvar} 1)
        break()
      elseif(NOT ";${__checked};" MATCHES ";${OPT};")
        list(APPEND __queue ${CPU_${OPT}_FORCE})
      endif()
      list(APPEND __checked ${OPT})
    endforeach()
  endwhile()
endmacro()

macro(ocv_append_optimization_flag var OPT)
  if(CPU_${OPT}_FLAGS_CONFLICT)
    string(REGEX REPLACE " ${CPU_${OPT}_FLAGS_CONFLICT}" "" ${var} " ${${var}} ")
    string(REGEX REPLACE "^ +" "" ${var} "${${var}}")
  endif()
  set(${var} "${${var}} ${CPU_${OPT}_FLAGS_ON}")
endmacro()

# Support GCC -march=native or Intel Compiler -xHost flags
if(";${CPU_BASELINE};" MATCHES ";NATIVE;" OR ";${CPU_BASELINE};" MATCHES ";HOST;")
  set(CPU_BASELINE_DETECT ON)
  set(_add_native_flag ON)
elseif(";${CPU_BASELINE};" MATCHES ";DETECT;")
  set(CPU_BASELINE_DETECT ON)
elseif(" ${CMAKE_CXX_FLAGS} " MATCHES " -march=native | -xHost | /QxHost ")
  if(DEFINED CPU_BASELINE)
    message(STATUS "CPU: Detected '-march=native' or '-xHost' compiler flag. Force CPU_BASELINE=DETECT.")
  endif()
  set(CPU_BASELINE "DETECT" CACHE STRING "${HELP_CPU_BASELINE}")
  set(CPU_BASELINE_DETECT ON)
endif()

if(X86 OR X86_64)
  ocv_update(CPU_KNOWN_OPTIMIZATIONS "SSE;SSE2;SSE3;SSSE3;SSE4_1;POPCNT;SSE4_2;FP16;FMA3;AVX;AVX2;AVX_512F;AVX512_COMMON;AVX512_KNL;AVX512_KNM;AVX512_SKX;AVX512_CNL;AVX512_CLX;AVX512_ICL")

  ocv_update(CPU_AVX512_COMMON_GROUP "AVX_512F;AVX_512CD")
  ocv_update(CPU_AVX512_KNL_GROUP "AVX512_COMMON;AVX512_KNL_EXTRA")
  ocv_update(CPU_AVX512_KNM_GROUP "AVX512_KNL;AVX512_KNM_EXTRA;AVX_512VPOPCNTDQ")
  ocv_update(CPU_AVX512_SKX_GROUP "AVX512_COMMON;AVX_512VL;AVX_512BW;AVX_512DQ")
  ocv_update(CPU_AVX512_CNL_GROUP "AVX512_SKX;AVX_512IFMA;AVX_512VBMI")
  ocv_update(CPU_AVX512_CLX_GROUP "AVX512_SKX;AVX_512VNNI")
  ocv_update(CPU_AVX512_ICL_GROUP "AVX512_SKX;AVX_512IFMA;AVX_512VBMI;AVX_512VNNI;AVX_512VBMI2;AVX_512BITALG;AVX_512VPOPCNTDQ") # ? VPCLMULQDQ, GFNI, VAES

  ocv_update(CPU_SSE_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_sse.cpp")
  ocv_update(CPU_SSE2_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_sse2.cpp")
  ocv_update(CPU_SSE3_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_sse3.cpp")
  ocv_update(CPU_SSSE3_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_ssse3.cpp")
  ocv_update(CPU_SSE4_1_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_sse41.cpp")
  ocv_update(CPU_SSE4_2_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_sse42.cpp")
  ocv_update(CPU_POPCNT_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_popcnt.cpp")
  ocv_update(CPU_AVX_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_avx.cpp")
  ocv_update(CPU_AVX2_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_avx2.cpp")
  ocv_update(CPU_FP16_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_fp16.cpp")
  ocv_update(CPU_AVX_512F_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_avx512.cpp")
  ocv_update(CPU_AVX512_COMMON_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_avx512common.cpp")
  ocv_update(CPU_AVX512_KNL_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_avx512knl.cpp")
  ocv_update(CPU_AVX512_KNM_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_avx512knm.cpp")
  ocv_update(CPU_AVX512_SKX_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_avx512skx.cpp")
  ocv_update(CPU_AVX512_CNL_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_avx512cnl.cpp")
  ocv_update(CPU_AVX512_CLX_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_avx512clx.cpp")
  ocv_update(CPU_AVX512_ICL_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_avx512icl.cpp")

  if(NOT OPENCV_CPU_OPT_IMPLIES_IGNORE)
    ocv_update(CPU_AVX512_ICL_IMPLIES "AVX512_SKX")
    ocv_update(CPU_AVX512_CLX_IMPLIES "AVX512_SKX")
    ocv_update(CPU_AVX512_CNL_IMPLIES "AVX512_SKX")
    ocv_update(CPU_AVX512_SKX_IMPLIES "AVX512_COMMON")
    ocv_update(CPU_AVX512_KNM_IMPLIES "AVX512_KNL")
    ocv_update(CPU_AVX512_KNL_IMPLIES "AVX512_COMMON")
    ocv_update(CPU_AVX512_COMMON_IMPLIES "AVX_512F")
    ocv_update(CPU_AVX_512F_IMPLIES "AVX2")
    ocv_update(CPU_AVX_512F_FORCE "") # Don't force other optimizations
    ocv_update(CPU_AVX2_IMPLIES "AVX;FMA3;FP16")
    ocv_update(CPU_FMA3_IMPLIES "AVX2")
    ocv_update(CPU_FMA3_FORCE "") # Don't force other optimizations
    ocv_update(CPU_FP16_IMPLIES "AVX")
    ocv_update(CPU_FP16_FORCE "") # Don't force other optimizations
    ocv_update(CPU_AVX_IMPLIES "SSE4_2")
    ocv_update(CPU_SSE4_2_IMPLIES "SSE4_1;POPCNT")
    ocv_update(CPU_POPCNT_IMPLIES "SSE4_1")
    ocv_update(CPU_POPCNT_FORCE "") # Don't force other optimizations
    ocv_update(CPU_SSE4_1_IMPLIES "SSE3;SSSE3")
    ocv_update(CPU_SSSE3_IMPLIES "SSE3")
    ocv_update(CPU_SSE3_IMPLIES "SSE2")
    ocv_update(CPU_SSE2_IMPLIES "SSE")
  endif()

  if(CV_ICC)
    macro(ocv_intel_compiler_optimization_option name unix_flags msvc_flags)
      ocv_update(CPU_${name}_FLAGS_NAME "${name}")
      if(MSVC)
        set(enable_flags "${msvc_flags}")
        set(flags_conflict "/arch:[^ ]*|/Qx:[^ ]+")
      else()
        set(enable_flags "${unix_flags}")
        set(flags_conflict "-msse[^ ]*|-mssse3|-mavx[^ ]*|-march[^ ]*|-x[^ ]+")
      endif()
      ocv_update(CPU_${name}_FLAGS_ON "${enable_flags}")
      if(flags_conflict)
        ocv_update(CPU_${name}_FLAGS_CONFLICT "${flags_conflict}")
      endif()
    endmacro()
    ocv_intel_compiler_optimization_option(AVX2 "-march=core-avx2" "/arch:CORE-AVX2")
    ocv_intel_compiler_optimization_option(FP16 "-mavx" "/arch:AVX")
    ocv_intel_compiler_optimization_option(AVX "-mavx" "/arch:AVX")
    ocv_intel_compiler_optimization_option(FMA3 "" "")
    ocv_intel_compiler_optimization_option(POPCNT "-mpopcnt" "")  # -mpopcnt is available since ICC 19.0.0
    ocv_intel_compiler_optimization_option(SSE4_2 "-msse4.2" "/arch:SSE4.2")
    ocv_intel_compiler_optimization_option(SSE4_1 "-msse4.1" "/arch:SSE4.1")
    ocv_intel_compiler_optimization_option(SSE3 "-msse3" "/arch:SSE3")
    ocv_intel_compiler_optimization_option(SSSE3 "-mssse3" "/arch:SSSE3")
    ocv_intel_compiler_optimization_option(SSE2 "-msse2" "/arch:SSE2")
    if(NOT X86_64) # x64 compiler doesn't support /arch:sse
      ocv_intel_compiler_optimization_option(SSE "-msse" "/arch:SSE")
    endif()
    ocv_intel_compiler_optimization_option(AVX_512F "-xCOMMON-AVX512" "/Qx:COMMON-AVX512")
    ocv_intel_compiler_optimization_option(AVX512_COMMON "-xCOMMON-AVX512" "/Qx:COMMON-AVX512")
    ocv_intel_compiler_optimization_option(AVX512_KNL "-xKNL" "/Qx:KNL")
    ocv_intel_compiler_optimization_option(AVX512_KNM "-xKNM" "/Qx:KNM")
    ocv_intel_compiler_optimization_option(AVX512_SKX "-xSKYLAKE-AVX512" "/Qx:SKYLAKE-AVX512")
    ocv_intel_compiler_optimization_option(AVX512_CNL "-xCANNONLAKE" "/Qx:CANNONLAKE")
    ocv_intel_compiler_optimization_option(AVX512_CLX "-xCASCADELAKE" "/Qx:CASCADELAKE")
    ocv_intel_compiler_optimization_option(AVX512_ICL "-xICELAKE-CLIENT" "/Qx:ICELAKE-CLIENT")
  elseif(CV_GCC OR CV_CLANG)
    ocv_update(CPU_AVX2_FLAGS_ON "-mavx2")
    ocv_update(CPU_FP16_FLAGS_ON "-mf16c")
    ocv_update(CPU_AVX_FLAGS_ON "-mavx")
    ocv_update(CPU_FMA3_FLAGS_ON "-mfma")
    ocv_update(CPU_POPCNT_FLAGS_ON "-mpopcnt")
    ocv_update(CPU_SSE4_2_FLAGS_ON "-msse4.2")
    ocv_update(CPU_SSE4_1_FLAGS_ON "-msse4.1")
    ocv_update(CPU_SSE3_FLAGS_ON "-msse3")
    ocv_update(CPU_SSSE3_FLAGS_ON "-mssse3")
    ocv_update(CPU_SSE2_FLAGS_ON "-msse2")
    ocv_update(CPU_SSE_FLAGS_ON "-msse")
    if(NOT (CV_GCC AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS "5.0"))  # GCC >= 5.0
      ocv_update(CPU_AVX_512F_FLAGS_ON "-mavx512f")
      ocv_update(CPU_AVX_512CD_FLAGS_ON "-mavx512cd")
      ocv_update(CPU_AVX512_KNL_EXTRA_FLAGS_ON "-mavx512er -mavx512pf")
      ocv_update(CPU_AVX512_KNM_EXTRA_FLAGS_ON "-mavx5124fmaps -mavx5124vnniw")
      ocv_update(CPU_AVX_512BW_FLAGS_ON "-mavx512bw")
      ocv_update(CPU_AVX_512DQ_FLAGS_ON "-mavx512dq")
      ocv_update(CPU_AVX_512VL_FLAGS_ON "-mavx512vl")
      ocv_update(CPU_AVX_512IFMA_FLAGS_ON "-mavx512ifma")
      ocv_update(CPU_AVX_512VBMI_FLAGS_ON "-mavx512vbmi")
      ocv_update(CPU_AVX_512VNNI_FLAGS_ON "-mavx512vnni")
      ocv_update(CPU_AVX_512VBMI2_FLAGS_ON "-mavx512vbmi2")
      ocv_update(CPU_AVX_512BITALG_FLAGS_ON "-mavx512bitalg")
      ocv_update(CPU_AVX_512VPOPCNTDQ_FLAGS_ON "-mavx512vpopcntdq")
    else()
      ocv_update(CPU_AVX_512F_SUPPORTED OFF)
    endif()
  elseif(MSVC)
    ocv_update(CPU_AVX2_FLAGS_ON "/arch:AVX2")
    ocv_update(CPU_AVX_FLAGS_ON "/arch:AVX")
    ocv_update(CPU_FP16_FLAGS_ON "/arch:AVX")
    if(NOT X86_64)
      # 64-bit MSVC compiler uses SSE/SSE2 by default
      ocv_update(CPU_SSE_FLAGS_ON "/arch:SSE")
      ocv_update(CPU_SSE_SUPPORTED ON)
      ocv_update(CPU_SSE2_FLAGS_ON "/arch:SSE2")
      ocv_update(CPU_SSE2_SUPPORTED ON)
    else()
      ocv_update(CPU_SSE_SUPPORTED ON)
      ocv_update(CPU_SSE2_SUPPORTED ON)
      ocv_update(CPU_AVX_512F_FLAGS_ON "/arch:AVX512")
    endif()
    # Other instruction sets are supported by default since MSVC 2008 at least
  else()
    message(WARNING "TODO: Unsupported compiler")
  endif()

  if(NOT DEFINED CPU_DISPATCH)
    if(X86_64)
      set(CPU_DISPATCH "SSE4_1;SSE4_2;AVX;FP16;AVX2;AVX512_SKX" CACHE STRING "${HELP_CPU_DISPATCH}")
    else()
      set(CPU_DISPATCH "SSE4_1;SSE4_2;AVX;FP16" CACHE STRING "${HELP_CPU_DISPATCH}")
    endif()
  endif()

  if(NOT DEFINED CPU_BASELINE)
    if(APPLE)
      # MacOS X has limited set of possible supported H/W, so compiler is configured well
      set(CPU_BASELINE "DETECT" CACHE STRING "${HELP_CPU_BASELINE}")
    elseif(X86_64)
      set(CPU_BASELINE "SSE3" CACHE STRING "${HELP_CPU_BASELINE}")
    else()
      set(CPU_BASELINE "SSE2" CACHE STRING "${HELP_CPU_BASELINE}")
    endif()
  endif()

elseif(ARM OR AARCH64)
  ocv_update(CPU_NEON_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_neon.cpp")
  ocv_update(CPU_FP16_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_fp16.cpp")
  ocv_update(CPU_NEON_DOTPROD_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_dotprod.cpp")
  if(NOT AARCH64)
    ocv_update(CPU_KNOWN_OPTIMIZATIONS "VFPV3;NEON;FP16")
    if(NOT MSVC)
      ocv_update(CPU_VFPV3_FLAGS_ON "-mfpu=vfpv3")
      ocv_update(CPU_NEON_FLAGS_ON "-mfpu=neon")
      ocv_update(CPU_NEON_FLAGS_CONFLICT "-mfpu=[^ ]*")
      ocv_update(CPU_FP16_FLAGS_ON "-mfpu=neon-fp16 -mfp16-format=ieee")
      ocv_update(CPU_FP16_FLAGS_CONFLICT "-mfpu=[^ ]*")
    endif()
    ocv_update(CPU_FP16_IMPLIES "NEON")
  else()
    ocv_update(CPU_KNOWN_OPTIMIZATIONS "NEON;FP16;NEON_DOTPROD")
    ocv_update(CPU_NEON_FLAGS_ON "")
    ocv_update(CPU_FP16_IMPLIES "NEON")
    ocv_update(CPU_NEON_DOTPROD_FLAGS_ON "-march=armv8.2-a+dotprod")
    ocv_update(CPU_NEON_DOTPROD_IMPLIES "NEON")
    set(CPU_BASELINE "NEON;FP16" CACHE STRING "${HELP_CPU_BASELINE}")
  endif()
elseif(MIPS)
  ocv_update(CPU_MSA_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_msa.cpp")
  ocv_update(CPU_KNOWN_OPTIMIZATIONS "MSA")
  ocv_update(CPU_MSA_FLAGS_ON "-mmsa")
  set(CPU_BASELINE "DETECT" CACHE STRING "${HELP_CPU_BASELINE}")
elseif(PPC64LE)
  ocv_update(CPU_KNOWN_OPTIMIZATIONS "VSX;VSX3")
  ocv_update(CPU_VSX_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_vsx.cpp")
  ocv_update(CPU_VSX3_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_vsx3.cpp")

  if(NOT OPENCV_CPU_OPT_IMPLIES_IGNORE)
    ocv_update(CPU_VSX3_IMPLIES "VSX")
  endif()

  if(CV_CLANG AND (NOT ${CMAKE_CXX_COMPILER} MATCHES "xlc"))
    ocv_update(CPU_VSX_FLAGS_ON "-mvsx -maltivec")
    ocv_update(CPU_VSX3_FLAGS_ON "-mpower9-vector")
  else()
    ocv_update(CPU_VSX_FLAGS_ON "-mcpu=power8")
    ocv_update(CPU_VSX3_FLAGS_ON "-mcpu=power9 -mtune=power9")
  endif()

  set(CPU_DISPATCH "VSX3" CACHE STRING "${HELP_CPU_DISPATCH}")
  set(CPU_BASELINE "VSX" CACHE STRING "${HELP_CPU_BASELINE}")

elseif(RISCV)
  ocv_update(CPU_RVV_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_rvv.cpp")
  ocv_update(CPU_KNOWN_OPTIMIZATIONS "RVV")
  ocv_update(CPU_RVV_FLAGS_ON "")
  set(CPU_DISPATCH "RVV" CACHE STRING "${HELP_CPU_DISPATCH}")
  set(CPU_BASELINE "RVV" CACHE STRING "${HELP_CPU_BASELINE}")

elseif(LOONGARCH64)
  ocv_update(CPU_LASX_TEST_FILE "${OpenCV_SOURCE_DIR}/cmake/checks/cpu_lasx.cpp")
  ocv_update(CPU_KNOWN_OPTIMIZATIONS "LASX")
  ocv_update(CPU_LASX_FLAGS_ON "-mlasx")
  set(CPU_BASELINE "LASX" CACHE STRING "${HELP_CPU_BASELINE}")

endif()

# Helper values for cmake-gui
set(CPU_BASELINE "DETECT" CACHE STRING "${HELP_CPU_BASELINE}")
set(CPU_DISPATCH "" CACHE STRING "${HELP_CPU_DISPATCH}")
set_property(CACHE CPU_BASELINE PROPERTY STRINGS "" ${CPU_KNOWN_OPTIMIZATIONS})
set_property(CACHE CPU_DISPATCH PROPERTY STRINGS "" ${CPU_KNOWN_OPTIMIZATIONS})

# Update CPU_BASELINE_DETECT flag
if(";${CPU_BASELINE};" MATCHES ";DETECT;")
  set(CPU_BASELINE_DETECT ON)
endif()

set(CPU_BASELINE_FLAGS "")

set(CPU_BASELINE_FINAL "")
set(CPU_DISPATCH_FINAL "")

if(CV_DISABLE_OPTIMIZATION)
  set(CPU_DISPATCH "")
  set(CPU_DISPATCH_REQUIRE "")
endif()

if("x${CPU_DISPATCH}" STREQUAL "xALL")
  set(CPU_DISPATCH "${CPU_KNOWN_OPTIMIZATIONS}")
endif()

macro(ocv_check_compiler_optimization OPT)
  if(NOT DEFINED CPU_${OPT}_SUPPORTED)
    if((DEFINED CPU_${OPT}_FLAGS_ON AND NOT "x${CPU_${OPT}_FLAGS_ON}" STREQUAL "x") OR CPU_${OPT}_TEST_FILE)
      set(_varname "")
      if(CPU_${OPT}_TEST_FILE)
        set(__available 0)
        if(CPU_BASELINE_DETECT)
          set(_varname "HAVE_CPU_${OPT}_SUPPORT")
          ocv_check_compiler_flag(CXX "${CPU_BASELINE_FLAGS}" "${_varname}" "${CPU_${OPT}_TEST_FILE}")
          if(${_varname})
            list(APPEND CPU_BASELINE_FINAL ${OPT})
            set(CPU_${OPT}_ENABLED_DEFAULT ON)
            set(__available 1)
          endif()
        endif()
        if(NOT __available)
          if(NOT "x${CPU_${OPT}_FLAGS_NAME}" STREQUAL "x")
            set(_varname "HAVE_CPU_${CPU_${OPT}_FLAGS_NAME}")
            set(_compile_flags "${CPU_BASELINE_FLAGS}")
            ocv_append_optimization_flag(_compile_flags ${OPT})
            ocv_check_compiler_flag(CXX "${_compile_flags}" "${_varname}" "${CPU_${OPT}_TEST_FILE}")
          elseif(NOT "x${CPU_${OPT}_FLAGS_ON}" STREQUAL "x")
            ocv_check_flag_support(CXX "${CPU_${OPT}_FLAGS_ON}" _varname "" "${CPU_${OPT}_TEST_FILE}")
          else()
            set(_varname "HAVE_CPU_${OPT}_SUPPORT")
            set(_compile_flags "${CPU_BASELINE_FLAGS}")
            ocv_append_optimization_flag(_compile_flags ${OPT})
            ocv_check_compiler_flag(CXX "${_compile_flags}" "${_varname}" "${CPU_${OPT}_TEST_FILE}")
          endif()
        endif()
      else()
        ocv_check_flag_support(CXX "${CPU_${OPT}_FLAGS_ON}" _varname "")
      endif()
      if(_varname AND ${_varname})
        set(CPU_${OPT}_SUPPORTED ON)
      elseif(NOT CPU_${OPT}_SUPPORTED)
        message(STATUS "${OPT} is not supported by C++ compiler")
      endif()
    else()
      set(CPU_${OPT}_SUPPORTED ON)
    endif()
  endif()
endmacro()

foreach(OPT ${CPU_KNOWN_OPTIMIZATIONS})
  set(CPU_${OPT}_USAGE_COUNT 0 CACHE INTERNAL "")
  if("${CPU_${OPT}_FLAGS_ON}" STREQUAL "disabled")
    set(CPU_${OPT}_SUPPORTED OFF)
  elseif(DEFINED CPU_${OPT}_GROUP)
    if(NOT DEFINED CPU_${OPT}_IMPLIES)
      set(CPU_${OPT}_IMPLIES "${CPU_${OPT}_GROUP}")
    endif()
    set(__disabled 0)
    set(__flags "")
    foreach(OPT2 ${CPU_${OPT}_GROUP})
      if("${CPU_${OPT2}_FLAGS_ON}" STREQUAL "disabled" OR (DEFINED CPU_${OPT2}_SUPPORTED AND NOT CPU_${OPT}_SUPPORTED))
        set(__disabled 1)
      endif()
      set(__flags "${__flags} ${CPU_${OPT2}_FLAGS_ON}")
      string(STRIP "${__flags}" __flags)
    endforeach()
    if(__disabled)
      set(CPU_${OPT}_SUPPORTED OFF)
    else()
      if(NOT DEFINED CPU_${OPT}_FLAGS_ON)
        set(CPU_${OPT}_FLAGS_ON "${__flags}")
      endif()
    endif()
  endif()
  if(NOT DEFINED CPU_${OPT}_FORCE)
    set(CPU_${OPT}_FORCE "${CPU_${OPT}_IMPLIES}")
  endif()
  #message("${OPT}: CPU_${OPT}_FLAGS_ON=${CPU_${OPT}_FLAGS_ON}")
endforeach()

if(_add_native_flag)
  set(_varname "HAVE_CPU_NATIVE_SUPPORT")
  ocv_check_compiler_flag(CXX "-march=native" "${_varname}" "")
  if(${_varname})
    set(CPU_BASELINE_FLAGS "${CPU_BASELINE_FLAGS} -march=native")
  else()
    set(_varname "HAVE_CPU_HOST_SUPPORT")
    if(MSVC)
      set(_flag "/QxHost")
    else()
      set(_flag "-xHost")
    endif()
    ocv_check_compiler_flag(CXX "${_flag}" "${_varname}" "")
    if(${_varname})
      set(CPU_BASELINE_FLAGS "${CPU_BASELINE_FLAGS} ${_flag}")
    endif()
  endif()
endif()

foreach(OPT ${CPU_KNOWN_OPTIMIZATIONS})
  set(__is_disabled 0)
  foreach(OPT2 ${CPU_BASELINE_DISABLE})
    ocv_is_optimization_in_list(__is_disabled ${OPT2} ${OPT})
    if(__is_disabled)
      break()
    endif()
  endforeach()
  if(__is_disabled)
    set(__is_from_baseline 0)
  else()
    if(CPU_${OPT}_SUPPORTED AND CPU_BASELINE_DETECT)
      list(APPEND CPU_BASELINE_FINAL ${OPT})
    endif()
    ocv_is_optimization_in_list(__is_from_baseline ${OPT} ${CPU_BASELINE_REQUIRE})
    if(NOT __is_from_baseline)
      ocv_is_optimization_in_list(__is_from_baseline ${OPT} ${CPU_BASELINE})
    endif()
  endif()
  ocv_is_optimization_in_list(__is_from_dispatch ${OPT} ${CPU_DISPATCH_REQUIRE})
  if(NOT __is_from_dispatch)
    ocv_is_optimization_in_list(__is_from_dispatch ${OPT} ${CPU_DISPATCH})
  endif()
  if(__is_from_dispatch OR __is_from_baseline OR CPU_BASELINE_DETECT)
    ocv_check_compiler_optimization(${OPT})
  endif()
  if(CPU_BASELINE_DETECT AND NOT __is_from_baseline AND NOT __is_disabled)
    ocv_is_optimization_in_list(__is_from_baseline ${OPT} ${CPU_BASELINE_FINAL})
  endif()
  if(CPU_${OPT}_SUPPORTED)
    if(";${CPU_DISPATCH};" MATCHES ";${OPT};" AND NOT __is_from_baseline)
      list(APPEND CPU_DISPATCH_FINAL ${OPT})
    elseif(__is_from_baseline)
      if(NOT ";${CPU_BASELINE_FINAL};" MATCHES ";${OPT};")
        list(APPEND CPU_BASELINE_FINAL ${OPT})
      endif()
      if(NOT CPU_${OPT}_ENABLED_DEFAULT)  # Don't change compiler flags in 'detection' mode
        ocv_append_optimization_flag(CPU_BASELINE_FLAGS ${OPT})
      endif()
    endif()
  endif()
endforeach()

foreach(OPT ${CPU_BASELINE_REQUIRE})
  if(NOT ";${CPU_BASELINE_FINAL};" MATCHES ";${OPT};")
    message(SEND_ERROR "Required baseline optimization is not supported: ${OPT} (CPU_BASELINE_REQUIRE=${CPU_BASELINE_REQUIRE})")
  endif()
endforeach()

foreach(OPT ${CPU_BASELINE})
  if(OPT STREQUAL "DETECT" OR OPT STREQUAL "HOST" OR OPT STREQUAL "NATIVE")
    # nothing
  elseif(NOT ";${CPU_BASELINE_FINAL};" MATCHES ";${OPT};")
    message(STATUS "Optimization ${OPT} is not available, skipped")
  endif()
endforeach()

foreach(OPT ${CPU_DISPATCH_REQUIRE})
  if(";${CPU_DISPATCH_FINAL};" MATCHES ";${OPT};")
    # OK
  elseif(";${CPU_BASELINE_FINAL};" MATCHES ";${OPT};")
    message(SEND_ERROR "Dispatched optimization ${OPT} is in baseline list (CPU_DISPATCH_REQUIRE=${CPU_DISPATCH_REQUIRE})")
  else()
    message(SEND_ERROR "Required dispatch optimization is not supported: ${OPT} (CPU_DISPATCH_REQUIRE=${CPU_DISPATCH_REQUIRE})")
  endif()
endforeach()

foreach(OPT ${CPU_DISPATCH})
  if(";${CPU_DISPATCH_FINAL};" MATCHES ";${OPT};")
    # OK
  elseif(";${CPU_BASELINE_FINAL};" MATCHES ";${OPT};")
    # OK
  else()
    message(STATUS "Dispatch optimization ${OPT} is not available, skipped")
  endif()
endforeach()

#message(STATUS "CPU_BASELINE_FINAL=${CPU_BASELINE_FINAL}")
#message(STATUS "CPU_DISPATCH_FINAL=${CPU_DISPATCH_FINAL}")

#if(CPU_DISPATCH_FINAL AND NOT PYTHON_DEFAULT_EXECUTABLE)
#  message(FATAL_ERROR "Python is required for CPU dispatched optimization support")
#endif()

macro(ocv_compiler_optimization_options)
  set(__flags "${OPENCV_EXTRA_CXX_FLAGS} ${CPU_BASELINE_FLAGS}")
  if(NOT __flags STREQUAL CACHED_CPU_BASELINE_FLAGS)
    set(CACHED_CPU_BASELINE_FLAGS "${__flags}" CACHE INTERNAL "" FORCE)
    ocv_clear_vars(HAVE_CPU_BASELINE_FLAGS)
  endif()
  ocv_check_compiler_flag(CXX "${__flags}" HAVE_CPU_BASELINE_FLAGS)
  if(NOT HAVE_CPU_BASELINE_FLAGS)
    message(FATAL_ERROR "Compiler doesn't support baseline optimization flags: ${CPU_BASELINE_FLAGS}")
  endif()
  add_extra_compiler_option_force("${CPU_BASELINE_FLAGS}")

  foreach(OPT ${CPU_DISPATCH_FINAL})
    set(__dispatch_flags "")
    set(__dispatch_definitions "")
    set(__dispatch_opts "")
    set(__dispatch_opts_force "")
    foreach(OPT2 ${CPU_KNOWN_OPTIMIZATIONS})
      if(NOT CPU_${OPT2}_SUPPORTED)
        #continue()
      else()
      ocv_is_optimization_in_list(__is_from_baseline ${OPT2} ${CPU_BASELINE_FINAL})
      if(NOT __is_from_baseline)
        ocv_is_optimization_in_list(__is_active ${OPT2} ${OPT})
        if(__is_active)
          ocv_append_optimization_flag(__dispatch_flags ${OPT2})
          list(APPEND __dispatch_definitions "CV_CPU_COMPILE_${OPT2}=1")
          list(APPEND __dispatch_opts "${OPT2}")
        endif()
        ocv_is_optimization_in_force_list(__is_force ${OPT2} ${OPT})
        if(__is_force)
          list(APPEND __dispatch_opts_force "${OPT2}")
        endif()
      endif()
      endif()
    endforeach()
    set(__flags "${OPENCV_EXTRA_CXX_FLAGS} ${__dispatch_flags}")
    if(NOT __flags STREQUAL CACHED_CPU_DISPATCH_${OPT}_FLAGS)
      set(CACHED_CPU_DISPATCH_${OPT}_FLAGS "${__flags}" CACHE INTERNAL "" FORCE)
      ocv_clear_vars(HAVE_CPU_DISPATCH_FLAGS_${OPT})
    endif()
    ocv_check_compiler_flag(CXX "${__flags}" HAVE_CPU_DISPATCH_FLAGS_${OPT})
    if(NOT HAVE_CPU_DISPATCH_FLAGS_${OPT})
      message(FATAL_ERROR "Compiler doesn't support optimization flags for ${OPT} dispatch mode: ${__dispatch_flags}")
    endif()
    set(CPU_DISPATCH_FLAGS_${OPT} "${__dispatch_flags}")
    set(CPU_DISPATCH_DEFINITIONS_${OPT} "${__dispatch_definitions}")
    set(CPU_DISPATCH_${OPT}_INCLUDED "${__dispatch_opts}")
    set(CPU_DISPATCH_${OPT}_FORCED "${__dispatch_opts_force}")
  endforeach()

  if(ENABLE_POWERPC)
    add_extra_compiler_option("-mcpu=G3 -mtune=G5")
  endif()
endmacro()

macro(ocv_compiler_optimization_options_finalize)
  if((CV_GCC OR CV_CLANG) AND (X86 OR X86_64))
    if(NOT APPLE AND CMAKE_SIZEOF_VOID_P EQUAL 4)
      if(OPENCV_EXTRA_CXX_FLAGS MATCHES "-m(sse2|avx)")
        add_extra_compiler_option(-mfpmath=sse) # !! important - be on the same wave with x64 compilers
      else()
        add_extra_compiler_option(-mfpmath=387)
      endif()
    endif()
  endif()

  if(MSVC)
    # Generate Intrinsic Functions
    set(OPENCV_EXTRA_FLAGS "${OPENCV_EXTRA_FLAGS} /Oi")
  endif(MSVC)
endmacro()

macro(ocv_compiler_optimization_process_sources SOURCES_VAR_NAME LIBS_VAR_NAME TARGET_BASE_NAME)
  set(__result "")
  set(__result_libs "")
  foreach(OPT ${CPU_DISPATCH_FINAL})
    set(__result_${OPT} "")
  endforeach()
  foreach(fname ${${SOURCES_VAR_NAME}})
    string(TOLOWER "${fname}" fname_LOWER)
    get_filename_component(fname_LOWER "${fname_LOWER}" NAME)
    if(fname_LOWER MATCHES ".+\\.([^\\.]*)\\.cpp$")
      string(TOUPPER "${CMAKE_MATCH_1}" OPT_)
      if(OPT_ MATCHES "(CUDA.*|DISPATCH.*|OCL)") # don't touch files like filename.cuda.cpp
        list(APPEND __result "${fname}")
        #continue()
      elseif(CV_DISABLE_OPTIMIZATION OR NOT CV_ENABLE_INTRINSICS)
        ocv_get_smart_file_name(fname_ "${fname}")
        message(STATUS "Excluding from source files list (optimization is disabled): ${fname_}")
        #continue()
      else()
        get_source_file_property(__definitions "${fname}" COMPILE_DEFINITIONS)
        if(__definitions)
          list(APPEND __definitions "CV_CPU_DISPATCH_MODE=${OPT_}")
        else()
          set(__definitions "CV_CPU_DISPATCH_MODE=${OPT_}")
        endif()
        set_source_files_properties("${fname}" PROPERTIES COMPILE_DEFINITIONS "${__definitions}")

        set(__opt_found 0)
        foreach(OPT ${CPU_BASELINE_FINAL})
          string(TOLOWER "${OPT}" OPT_LOWER)
          if(fname_LOWER MATCHES "\\.${OPT_LOWER}\\.cpp$")
#message("${fname} BASELINE-${OPT}")
            set(__opt_found 1)
            list(APPEND __result_${OPT} "${fname}")
            break()
          endif()
        endforeach()
        foreach(OPT ${CPU_DISPATCH_FINAL})
          foreach(OPT2 ${CPU_DISPATCH_${OPT}_FORCED})
            string(TOLOWER "${OPT2}" OPT2_LOWER)
            if(fname_LOWER MATCHES "\\.${OPT2_LOWER}\\.cpp$")
              list(APPEND __result_${OPT} "${fname}")
              math(EXPR CPU_${OPT}_USAGE_COUNT "${CPU_${OPT}_USAGE_COUNT}+1")
              set(CPU_${OPT}_USAGE_COUNT "${CPU_${OPT}_USAGE_COUNT}" CACHE INTERNAL "" FORCE)
#message("(${CPU_${OPT}_USAGE_COUNT})${fname} ${OPT}")
#message("    ${CPU_DISPATCH_${OPT}_INCLUDED}")
#message("    ${CPU_DISPATCH_DEFINITIONS_${OPT}}")
#message("    ${CPU_DISPATCH_FLAGS_${OPT}}")
              set(__opt_found 1)
              break()
            endif()
          endforeach()
          if(__opt_found)
            set(__opt_found 1)
            break()
          endif()
        endforeach()
        if(NOT __opt_found)
          ocv_get_smart_file_name(fname_ "${fname}")
          message(STATUS "Excluding from source files list: ${fname_}")
        endif()
      endif()
    else()
      list(APPEND __result "${fname}")
    endif()
  endforeach()

  foreach(OPT ${CPU_BASELINE_FINAL} ${CPU_DISPATCH_FINAL})
    if(__result_${OPT})
#message("${OPT}: ${__result_${OPT}}")
      if(CMAKE_GENERATOR MATCHES "^Visual"
          OR OPENCV_CMAKE_CPU_OPTIMIZATIONS_FORCE_TARGETS
      )
        # MSVS generator is not able to properly order compilation flags:
        # extra flags are added before common flags, so switching between optimizations doesn't work correctly
        # Also CMAKE_CXX_FLAGS doesn't work (it is directory-based, so add_subdirectory is required)
        add_library(${TARGET_BASE_NAME}_${OPT} OBJECT ${__result_${OPT}})
        ocv_append_dependant_targets(${TARGET_BASE_NAME} ${TARGET_BASE_NAME}_${OPT})
        set_target_properties(${TARGET_BASE_NAME}_${OPT} PROPERTIES COMPILE_DEFINITIONS "${CPU_DISPATCH_DEFINITIONS_${OPT}}")
        set_target_properties(${TARGET_BASE_NAME}_${OPT} PROPERTIES COMPILE_FLAGS "${CPU_DISPATCH_FLAGS_${OPT}}")
        target_include_directories(${TARGET_BASE_NAME}_${OPT} PRIVATE $<TARGET_PROPERTY:${TARGET_BASE_NAME},INCLUDE_DIRECTORIES>)
        #list(APPEND __result_libs ${TARGET_BASE_NAME}_${OPT})
        list(APPEND __result "$<TARGET_OBJECTS:${TARGET_BASE_NAME}_${OPT}>")
        if(ENABLE_SOLUTION_FOLDERS)
          set_target_properties(${TARGET_BASE_NAME}_${OPT} PROPERTIES FOLDER "dispatched")
        endif()
      else()
        foreach(fname ${__result_${OPT}})
          get_source_file_property(__definitions "${fname}" COMPILE_DEFINITIONS)
          if(__definitions)
            list(APPEND __definitions "${CPU_DISPATCH_DEFINITIONS_${OPT}}")
          else()
            set(__definitions "${CPU_DISPATCH_DEFINITIONS_${OPT}}")
          endif()
          set_source_files_properties("${fname}" PROPERTIES COMPILE_DEFINITIONS "${__definitions}")
          set_source_files_properties("${fname}" PROPERTIES COMPILE_FLAGS "${CPU_DISPATCH_FLAGS_${OPT}}")
        endforeach()
        list(APPEND __result ${__result_${OPT}})
      endif()
    endif()
  endforeach()
  set(${SOURCES_VAR_NAME} "${__result}")
  list(APPEND ${LIBS_VAR_NAME} ${__result_libs})
endmacro()

macro(ocv_compiler_optimization_fill_cpu_config)
  set(OPENCV_CPU_BASELINE_DEFINITIONS_CONFIGMAKE "")
  foreach(OPT ${CPU_BASELINE_FINAL})
    set(OPENCV_CPU_BASELINE_DEFINITIONS_CONFIGMAKE "${OPENCV_CPU_BASELINE_DEFINITIONS_CONFIGMAKE}
#define CV_CPU_COMPILE_${OPT} 1
#define CV_CPU_BASELINE_COMPILE_${OPT} 1
")
  endforeach()

  set(OPENCV_CPU_BASELINE_DEFINITIONS_CONFIGMAKE "${OPENCV_CPU_BASELINE_DEFINITIONS_CONFIGMAKE}
#define CV_CPU_BASELINE_FEATURES 0 \\")
  foreach(OPT ${CPU_BASELINE_FINAL})
    if(NOT DEFINED CPU_${OPT}_FEATURE_ALIAS OR NOT "x${CPU_${OPT}_FEATURE_ALIAS}" STREQUAL "x")
      set(OPENCV_CPU_BASELINE_DEFINITIONS_CONFIGMAKE "${OPENCV_CPU_BASELINE_DEFINITIONS_CONFIGMAKE}
    , CV_CPU_${OPT} \\")
    endif()
  endforeach()
  set(OPENCV_CPU_BASELINE_DEFINITIONS_CONFIGMAKE "${OPENCV_CPU_BASELINE_DEFINITIONS_CONFIGMAKE}\n")

  set(__dispatch_modes "")
  foreach(OPT ${CPU_DISPATCH_FINAL})
    list(APPEND __dispatch_modes ${CPU_DISPATCH_${OPT}_FORCE} ${OPT})
  endforeach()
  list(REMOVE_DUPLICATES __dispatch_modes)
  foreach(OPT ${__dispatch_modes})
    set(OPENCV_CPU_DISPATCH_DEFINITIONS_CONFIGMAKE "${OPENCV_CPU_DISPATCH_DEFINITIONS_CONFIGMAKE}
#define CV_CPU_DISPATCH_COMPILE_${OPT} 1")
  endforeach()

  set(OPENCV_CPU_DISPATCH_DEFINITIONS_CONFIGMAKE "${OPENCV_CPU_DISPATCH_DEFINITIONS_CONFIGMAKE}
\n\n#define CV_CPU_DISPATCH_FEATURES 0 \\")
  foreach(OPT ${__dispatch_modes})
    if(NOT DEFINED CPU_${OPT}_FEATURE_ALIAS OR NOT "x${CPU_${OPT}_FEATURE_ALIAS}" STREQUAL "x")
      set(OPENCV_CPU_DISPATCH_DEFINITIONS_CONFIGMAKE "${OPENCV_CPU_DISPATCH_DEFINITIONS_CONFIGMAKE}
    , CV_CPU_${OPT} \\")
    endif()
  endforeach()
  set(OPENCV_CPU_DISPATCH_DEFINITIONS_CONFIGMAKE "${OPENCV_CPU_DISPATCH_DEFINITIONS_CONFIGMAKE}\n")

  set(OPENCV_CPU_CONTROL_DEFINITIONS_CONFIGMAKE "// AUTOGENERATED, DO NOT EDIT\n")
  foreach(OPT ${CPU_ALL_OPTIMIZATIONS})
    if(NOT DEFINED CPU_${OPT}_FEATURE_ALIAS OR NOT "x${CPU_${OPT}_FEATURE_ALIAS}" STREQUAL "x")
      set(OPENCV_CPU_CONTROL_DEFINITIONS_CONFIGMAKE "${OPENCV_CPU_CONTROL_DEFINITIONS_CONFIGMAKE}
#if !defined CV_DISABLE_OPTIMIZATION && defined CV_ENABLE_INTRINSICS && defined CV_CPU_COMPILE_${OPT}
#  define CV_TRY_${OPT} 1
#  define CV_CPU_FORCE_${OPT} 1
#  define CV_CPU_HAS_SUPPORT_${OPT} 1
#  define CV_CPU_CALL_${OPT}(fn, args) return (cpu_baseline::fn args)
#  define CV_CPU_CALL_${OPT}_(fn, args) return (opt_${OPT}::fn args)
#elif !defined CV_DISABLE_OPTIMIZATION && defined CV_ENABLE_INTRINSICS && defined CV_CPU_DISPATCH_COMPILE_${OPT}
#  define CV_TRY_${OPT} 1
#  define CV_CPU_FORCE_${OPT} 0
#  define CV_CPU_HAS_SUPPORT_${OPT} (cv::checkHardwareSupport(CV_CPU_${OPT}))
#  define CV_CPU_CALL_${OPT}(fn, args) if (CV_CPU_HAS_SUPPORT_${OPT}) return (opt_${OPT}::fn args)
#  define CV_CPU_CALL_${OPT}_(fn, args) if (CV_CPU_HAS_SUPPORT_${OPT}) return (opt_${OPT}::fn args)
#else
#  define CV_TRY_${OPT} 0
#  define CV_CPU_FORCE_${OPT} 0
#  define CV_CPU_HAS_SUPPORT_${OPT} 0
#  define CV_CPU_CALL_${OPT}(fn, args)
#  define CV_CPU_CALL_${OPT}_(fn, args)
#endif
#define __CV_CPU_DISPATCH_CHAIN_${OPT}(fn, args, mode, ...)  CV_CPU_CALL_${OPT}(fn, args); __CV_EXPAND(__CV_CPU_DISPATCH_CHAIN_ ## mode(fn, args, __VA_ARGS__))
")
    endif()
  endforeach()

  set(OPENCV_CPU_CONTROL_DEFINITIONS_CONFIGMAKE "${OPENCV_CPU_CONTROL_DEFINITIONS_CONFIGMAKE}
#define CV_CPU_CALL_BASELINE(fn, args) return (cpu_baseline::fn args)
#define __CV_CPU_DISPATCH_CHAIN_BASELINE(fn, args, mode, ...)  CV_CPU_CALL_BASELINE(fn, args) /* last in sequence */
")


  set(__file "${OpenCV_SOURCE_DIR}/modules/core/include/opencv2/core/cv_cpu_helper.h")
  if(EXISTS "${__file}")
    file(READ "${__file}" __content)
  endif()
  if(__content STREQUAL OPENCV_CPU_CONTROL_DEFINITIONS_CONFIGMAKE)
    #message(STATUS "${__file} contains same content")
  else()
    file(WRITE "${__file}" "${OPENCV_CPU_CONTROL_DEFINITIONS_CONFIGMAKE}")
    message(WARNING "${__file} is updated")
  endif()
endmacro()

macro(__ocv_add_dispatched_file filename target_src_var src_directory dst_directory precomp_hpp optimizations_var)
  if(NOT OPENCV_INITIAL_PASS)
    set(__codestr "
#include \"${src_directory}/${precomp_hpp}\"
#include \"${src_directory}/${filename}.simd.hpp\"
")

    set(__declarations_str "#define CV_CPU_SIMD_FILENAME \"${src_directory}/${filename}.simd.hpp\"")
    set(__dispatch_modes "BASELINE")

    set(__optimizations "${${optimizations_var}}")
    if(CV_DISABLE_OPTIMIZATION OR NOT CV_ENABLE_INTRINSICS)
      set(__optimizations "")
    endif()

    foreach(OPT ${__optimizations})
      string(TOLOWER "${OPT}" OPT_LOWER)
      set(__file "${CMAKE_CURRENT_BINARY_DIR}/${dst_directory}${filename}.${OPT_LOWER}.cpp")
      if(EXISTS "${__file}")
        file(READ "${__file}" __content)
      else()
        set(__content "")
      endif()
      if(__content STREQUAL __codestr)
        #message(STATUS "${__file} contains up-to-date content")
      else()
        file(WRITE "${__file}" "${__codestr}")
      endif()

      if(";${CPU_DISPATCH_FINAL};" MATCHES "${OPT}" OR __CPU_DISPATCH_INCLUDE_ALL)
        if(EXISTS "${src_directory}/${filename}.${OPT_LOWER}.cpp")
          message(STATUS "Using overridden ${OPT} source: ${src_directory}/${filename}.${OPT_LOWER}.cpp")
        else()
          list(APPEND ${target_src_var} "${__file}")
        endif()

        set(__declarations_str "${__declarations_str}
#define CV_CPU_DISPATCH_MODE ${OPT}
#include \"opencv2/core/private/cv_cpu_include_simd_declarations.hpp\"
")
        set(__dispatch_modes "${OPT}, ${__dispatch_modes}")
      endif()
    endforeach()

    set(__declarations_str "${__declarations_str}
#define CV_CPU_DISPATCH_MODES_ALL ${__dispatch_modes}

#undef CV_CPU_SIMD_FILENAME
")

    set(__file "${CMAKE_CURRENT_BINARY_DIR}/${dst_directory}${filename}.simd_declarations.hpp")
    if(EXISTS "${__file}")
      file(READ "${__file}" __content)
    endif()
    if(__content STREQUAL __declarations_str)
      #message(STATUS "${__file} contains up-to-date content")
    else()
      file(WRITE "${__file}" "${__declarations_str}")
    endif()
  endif()
endmacro()

macro(ocv_add_dispatched_file filename)
  set(__optimizations "${ARGN}")
  if(" ${ARGV1}" STREQUAL " TEST")
    list(REMOVE_AT __optimizations 0)
    __ocv_add_dispatched_file("${filename}" "OPENCV_MODULE_${the_module}_TEST_SOURCES_DISPATCHED" "${CMAKE_CURRENT_LIST_DIR}/test" "test/" "test_precomp.hpp" __optimizations)
  else()
    __ocv_add_dispatched_file("${filename}" "OPENCV_MODULE_${the_module}_SOURCES_DISPATCHED" "${CMAKE_CURRENT_LIST_DIR}/src" "" "precomp.hpp" __optimizations)
  endif()
endmacro()


# Workaround to support code which always require all code paths
macro(ocv_add_dispatched_file_force_all)
  set(__CPU_DISPATCH_INCLUDE_ALL 1)
  ocv_add_dispatched_file(${ARGN})
  unset(__CPU_DISPATCH_INCLUDE_ALL)
endmacro()


if(CV_DISABLE_OPTIMIZATION OR CV_ICC)
  ocv_update(CV_ENABLE_UNROLLED 0)
else()
  ocv_update(CV_ENABLE_UNROLLED 1)
endif()
