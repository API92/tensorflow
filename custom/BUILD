load("//tensorflow/lite:build_def.bzl", "tflite_cc_shared_object", "tflite_copts", "tflite_linkopts")
load("//tensorflow/lite/delegates/flex:build_def.bzl", "tflite_flex_cc_library")

cc_library(
    name = "ops_to_register",
    hdrs = ["includes/ops_to_register.h"],
    visibility = ["//visibility:public"],
    includes = ["includes"],
    defines = [
        "SELECTIVE_REGISTRATION",
        "SUPPORT_SELECTIVE_REGISTRATION",
    ],
)

cc_library(
  name = "registrators",
  srcs = [
      "//tensorflow/core/ops:image_ops.cc",
  ],
  deps = [
    "//tensorflow/core:protos_all_cc",
    "//tensorflow/core:framework_internal",
  ],
  linkstatic=True,
  alwayslink=True,
)

tflite_flex_cc_library(
  name = "faces_flex_delegate",
  models = ["vargfacenet.tflite"],
  additional_deps = [
      "//tensorflow/core/kernels/image:image_ops",
      "//tensorflow/core/kernels/image:scale_and_translate_op",
      "//tensorflow/core/kernels/image:decode_image_op",
      ":registrators",
  ],
)

tflite_cc_shared_object(
    name = "libtensorflow-lite.so",
    defines = ["TFLITE_BUILD_WITH_XNNPACK_DELEGATE"],
    # Until we have more granular symbol export for the C++ API on Windows,
    # export all symbols.
    features = ["windows_export_all_symbols"],
    linkopts = select({
        "//tensorflow:macos": [
            "-Wl,-exported_symbols_list,$(location //tensorflow/lite:tflite_exported_symbols.lds)",
        ],
        "//tensorflow:windows": [],
        "//conditions:default": [
            "-Wl,-z,defs",
            "-Wl,--version-script,$(location //tensorflow/lite:tflite_version_script.lds)",
        ],
    }),
    #per_os_targets = True,
    deps = [
        "//tensorflow/lite:framework",
        "//tensorflow/lite/delegates/xnnpack:xnnpack_delegate",
        "//tensorflow/lite:tflite_exported_symbols.lds",
        "//tensorflow/lite:tflite_version_script.lds",
        "//tensorflow/lite/kernels:builtin_ops_all_linked",
        ":faces_flex_delegate",
    ],
    linkstatic = True,
)

cc_binary(
    name = "benchmark_model_flex",
    copts = ["-Wall"] + tflite_copts(),
    linkopts = tflite_linkopts() + select({
        "//tensorflow:android": [
            "-pie",  # Android 5.0 and later supports only PIE
            "-lm",  # some builtin ops, e.g., tanh, need -lm
            "-Wl,--rpath=/data/local/tmp/",  # Hexagon delegate libraries should be in /data/local/tmp
        ],
        "//conditions:default": [],
    }),
    tags = ["builder_default_android_arm64"],
    deps = [
        "//tensorflow/lite/tools/benchmark:benchmark_model_main",
        "//tensorflow/lite/delegates/xnnpack:xnnpack_delegate",
        "//tensorflow/lite/tools/delegates:xnnpack_delegate_provider",
        ":faces_flex_delegate",
    ],
    linkstatic=True,
)
