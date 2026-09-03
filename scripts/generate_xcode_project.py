#!/usr/bin/env python3
"""Write a classic PBX group Xcode project a Mac can open and archive."""

from __future__ import annotations

import json
import uuid
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "UmrahGuide.xcodeproj"

SWIFT_SOURCES = [
    "UmrahGuide/App/AppCopy.swift",
    "UmrahGuide/App/UmrahGuideApp.swift",
    "UmrahGuide/App/ContentView.swift",
    "UmrahGuide/Models/RitualStep.swift",
    "UmrahGuide/Models/ChecklistItem.swift",
    "UmrahGuide/Models/Dua.swift",
    "UmrahGuide/Data/RitualCatalog.swift",
    "UmrahGuide/Data/ChecklistCatalog.swift",
    "UmrahGuide/Data/DuaCatalog.swift",
    "UmrahGuide/Persistence/ChecklistStore.swift",
    "UmrahGuide/Theme/Theme.swift",
    "UmrahGuide/Views/Components/DisclaimerBanner.swift",
    "UmrahGuide/Views/Components/SectionCard.swift",
    "UmrahGuide/Views/PerformUmrah/PerformUmrahView.swift",
    "UmrahGuide/Views/PerformUmrah/RitualStepDetailView.swift",
    "UmrahGuide/Views/Checklist/ChecklistView.swift",
    "UmrahGuide/Views/Duas/DuasView.swift",
    "UmrahGuide/Views/Duas/DuaDetailView.swift",
    "UmrahGuide/Views/About/AboutView.swift",
    "UmrahGuide/Views/About/LegalDocumentView.swift",
]

RESOURCES = [
    "UmrahGuide/Resources/Assets.xcassets",
    "UmrahGuide/Resources/PrivacyInfo.xcprivacy",
]

TESTS = [
    "UmrahGuideTests/ChecklistStoreTests.swift",
    "UmrahGuideTests/RitualCatalogTests.swift",
]


def hid(name: str) -> str:
    """Stable 24-char hex ID derived from a name."""
    return uuid.uuid5(uuid.NAMESPACE_URL, f"umrah-guide:{name}").hex[:24].upper()


def file_ref(path: str, last_known: str) -> str:
    ident = hid(f"fileref:{path}")
    name = Path(path).name
    return (
        f"\t\t{ident} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = {last_known}; "
        f'path = {name if "/" not in name else json.dumps(name)}; sourceTree = "<group>"; }};'
    )


def pbx_file_ref_line(ident: str, name: str, last_known: str, path: str | None = None, extras: str = "") -> str:
    path_value = path or name
    quoted_path = path_value if path_value.isidentifier() or path_value.endswith((".swift", ".xcprivacy")) else json.dumps(path_value)
    if " " in path_value or path_value.endswith(".app") or path_value.endswith(".xctest"):
        quoted_path = json.dumps(path_value)
    extra = f" {extras}" if extras else ""
    return (
        f"\t\t{ident} /* {name} */ = {{isa = PBXFileReference;{extra} lastKnownFileType = {last_known}; "
        f"path = {quoted_path}; sourceTree = \"<group>\"; }};"
    )


def group_children(paths: list[str], extra_ids: list[str] | None = None) -> str:
    ids = [f"\t\t\t\t{hid(f'fileref:{p}')} /* {Path(p).name} */," for p in paths]
    if extra_ids:
        ids.extend(f"\t\t\t\t{item}," for item in extra_ids)
    return "\n".join(ids)


def settings_block(pairs: dict[str, str], indent: str = "\t\t\t\t") -> str:
    lines = []
    for key, value in pairs.items():
        if value.startswith("(") or value.startswith("{") or value.startswith("YES") or value.startswith("NO") or value.startswith("\""):
            lines.append(f"{indent}{key} = {value};")
        elif " " in value or value == "" or "-" in value or "." in value or "/" in value or "$" in value:
            lines.append(f"{indent}{key} = {json.dumps(value)};")
        else:
            lines.append(f"{indent}{key} = {value};")
    return "\n".join(lines)


COMMON_DEBUG = {
    "ALWAYS_SEARCH_USER_PATHS": "NO",
    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
    "CLANG_ANALYZER_NONNULL": "YES",
    "CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION": "YES_AGGRESSIVE",
    "CLANG_CXX_LANGUAGE_STANDARD": '"gnu++20"',
    "CLANG_ENABLE_MODULES": "YES",
    "CLANG_ENABLE_OBJC_ARC": "YES",
    "CLANG_ENABLE_OBJC_WEAK": "YES",
    "CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING": "YES",
    "CLANG_WARN_BOOL_CONVERSION": "YES",
    "CLANG_WARN_COMMA": "YES",
    "CLANG_WARN_CONSTANT_CONVERSION": "YES",
    "CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS": "YES",
    "CLANG_WARN_DIRECT_OBJC_ISA_USAGE": "YES_ERROR",
    "CLANG_WARN_DOCUMENTATION_COMMENTS": "YES",
    "CLANG_WARN_EMPTY_BODY": "YES",
    "CLANG_WARN_ENUM_CONVERSION": "YES",
    "CLANG_WARN_INFINITE_RECURSION": "YES",
    "CLANG_WARN_INT_CONVERSION": "YES",
    "CLANG_WARN_NON_LITERAL_NULL_CONVERSION": "YES",
    "CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF": "YES",
    "CLANG_WARN_OBJC_LITERAL_CONVERSION": "YES",
    "CLANG_WARN_OBJC_ROOT_CLASS": "YES_ERROR",
    "CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER": "YES",
    "CLANG_WARN_RANGE_LOOP_ANALYSIS": "YES",
    "CLANG_WARN_STRICT_PROTOTYPES": "YES",
    "CLANG_WARN_SUSPICIOUS_MOVE": "YES",
    "CLANG_WARN_UNGUARDED_AVAILABILITY": "YES_AGGRESSIVE",
    "CLANG_WARN_UNREACHABLE_CODE": "YES",
    "CLANG_WARN__DUPLICATE_METHOD_MATCH": "YES",
    "COPY_PHASE_STRIP": "NO",
    "DEBUG_INFORMATION_FORMAT": "dwarf",
    "ENABLE_STRICT_OBJC_MSGSEND": "YES",
    "ENABLE_TESTABILITY": "YES",
    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
    "GCC_C_LANGUAGE_STANDARD": "gnu17",
    "GCC_DYNAMIC_NO_PIC": "NO",
    "GCC_NO_COMMON_BLOCKS": "YES",
    "GCC_OPTIMIZATION_LEVEL": "0",
    "GCC_PREPROCESSOR_DEFINITIONS": '("DEBUG=1", "$(inherited)", )',
    "GCC_WARN_64_TO_32_BIT_CONVERSION": "YES",
    "GCC_WARN_ABOUT_RETURN_TYPE": "YES_ERROR",
    "GCC_WARN_UNDECLARED_SELECTOR": "YES",
    "GCC_WARN_UNINITIALIZED_AUTOS": "YES_AGGRESSIVE",
    "GCC_WARN_UNUSED_FUNCTION": "YES",
    "GCC_WARN_UNUSED_VARIABLE": "YES",
    "IPHONEOS_DEPLOYMENT_TARGET": "17.0",
    "LOCALIZATION_PREFERS_STRING_CATALOGS": "YES",
    "MTL_ENABLE_DEBUG_INFO": "INCLUDE_SOURCE",
    "MTL_FAST_MATH": "YES",
    "ONLY_ACTIVE_ARCH": "YES",
    "SDKROOT": "iphoneos",
    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": '"DEBUG $(inherited)"',
    "SWIFT_OPTIMIZATION_LEVEL": '"-Onone"',
    "SWIFT_STRICT_CONCURRENCY": "targeted",
}

COMMON_RELEASE = {
    **{k: v for k, v in COMMON_DEBUG.items() if k not in {
        "DEBUG_INFORMATION_FORMAT",
        "ENABLE_TESTABILITY",
        "GCC_DYNAMIC_NO_PIC",
        "GCC_OPTIMIZATION_LEVEL",
        "GCC_PREPROCESSOR_DEFINITIONS",
        "MTL_ENABLE_DEBUG_INFO",
        "ONLY_ACTIVE_ARCH",
        "SWIFT_ACTIVE_COMPILATION_CONDITIONS",
        "SWIFT_OPTIMIZATION_LEVEL",
    }},
    "DEBUG_INFORMATION_FORMAT": '"dwarf-with-dsym"',
    "ENABLE_NS_ASSERTIONS": "NO",
    "MTL_ENABLE_DEBUG_INFO": "NO",
    "SWIFT_COMPILATION_MODE": "wholemodule",
    "VALIDATE_PRODUCT": "YES",
}

APP_KEYS = {
    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
    "CODE_SIGN_STYLE": "Automatic",
    "CURRENT_PROJECT_VERSION": "1",
    "ENABLE_PREVIEWS": "YES",
    "GENERATE_INFOPLIST_FILE": "YES",
    "INFOPLIST_KEY_CFBundleDisplayName": "Umrah Guide",
    "INFOPLIST_KEY_ITSAppUsesNonExemptEncryption": "NO",
    "INFOPLIST_KEY_LSApplicationCategoryType": "public.app-category.reference",
    "INFOPLIST_KEY_UIApplicationSceneManifest_Generation": "YES",
    "INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents": "YES",
    "INFOPLIST_KEY_UILaunchScreen_Generation": "YES",
    "INFOPLIST_KEY_UISupportedInterfaceOrientations": '"UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight"',
    "INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad": '"UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight"',
    "LD_RUNPATH_SEARCH_PATHS": '("$(inherited)", "@executable_path/Frameworks", )',
    "MARKETING_VERSION": "1.0",
    "PRODUCT_BUNDLE_IDENTIFIER": "ai.desklink.umrahguide",
    "PRODUCT_NAME": "UmrahGuide",
    "SUPPORTED_PLATFORMS": "iphoneos iphonesimulator",
    "SUPPORTS_MACCATALYST": "NO",
    "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD": "NO",
    "SUPPORTS_XR_DESIGNED_FOR_IPHONE_IPAD": "NO",
    "SWIFT_EMIT_LOC_STRINGS": "YES",
    "SWIFT_VERSION": "5.0",
    "TARGETED_DEVICE_FAMILY": '"1"',
}

TEST_KEYS = {
    "BUNDLE_LOADER": '"$(TEST_HOST)"',
    "CODE_SIGN_STYLE": "Automatic",
    "CURRENT_PROJECT_VERSION": "1",
    "GENERATE_INFOPLIST_FILE": "YES",
    "IPHONEOS_DEPLOYMENT_TARGET": "17.0",
    "MARKETING_VERSION": "1.0",
    "PRODUCT_BUNDLE_IDENTIFIER": "ai.desklink.umrahguide.tests",
    "PRODUCT_NAME": '"$(TARGET_NAME)"',
    "SUPPORTED_PLATFORMS": "iphoneos iphonesimulator",
    "SWIFT_EMIT_LOC_STRINGS": "NO",
    "SWIFT_VERSION": "5.0",
    "TARGETED_DEVICE_FAMILY": '"1"',
    "TEST_HOST": '"$(BUILT_PRODUCTS_DIR)/UmrahGuide.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/UmrahGuide"',
}


def write_colorset(path: Path, light: tuple[float, float, float], dark: tuple[float, float, float]) -> None:
    path.mkdir(parents=True, exist_ok=True)
    def comps(rgb):
        return {
            "alpha": "1.000",
            "red": f"{rgb[0]:.3f}",
            "green": f"{rgb[1]:.3f}",
            "blue": f"{rgb[2]:.3f}",
        }

    data = {
        "colors": [
            {
                "color": {"color-space": "srgb", "components": comps(light)},
                "idiom": "universal",
            },
            {
                "appearances": [{"appearance": "luminosity", "value": "dark"}],
                "color": {"color-space": "srgb", "components": comps(dark)},
                "idiom": "universal",
            },
        ],
        "info": {"author": "xcode", "version": 1},
    }
    (path / "Contents.json").write_text(json.dumps(data, indent=2) + "\n")


def write_assets() -> None:
    assets = ROOT / "UmrahGuide" / "Resources" / "Assets.xcassets"
    (assets / "Contents.json").write_text(
        json.dumps({"info": {"author": "xcode", "version": 1}}, indent=2) + "\n"
    )
    (assets / "AppIcon.appiconset" / "Contents.json").write_text(
        json.dumps(
            {
                "images": [
                    {
                        "filename": "AppIcon.png",
                        "idiom": "universal",
                        "platform": "ios",
                        "size": "1024x1024",
                    }
                ],
                "info": {"author": "xcode", "version": 1},
            },
            indent=2,
        )
        + "\n"
    )
    colors = {
        "AccentColor": ((0.106, 0.369, 0.271), (0.435, 0.796, 0.604)),
        "AccentGreen": ((0.106, 0.369, 0.271), (0.435, 0.796, 0.604)),
        "WarmGold": ((0.604, 0.455, 0.125), (0.878, 0.753, 0.416)),
        "PageBackground": ((0.965, 0.953, 0.925), (0.063, 0.086, 0.071)),
        "CardBackground": ((1.000, 1.000, 1.000), (0.110, 0.141, 0.125)),
        "Ink": ((0.086, 0.098, 0.086), (0.953, 0.945, 0.918)),
        "MutedInk": ((0.239, 0.271, 0.251), (0.761, 0.784, 0.765)),
        "Caution": ((0.545, 0.180, 0.122), (0.941, 0.627, 0.565)),
    }
    for name, (light, dark) in colors.items():
        write_colorset(assets / f"{name}.colorset", light, dark)


def write_project() -> None:
    app_target = hid("target:app")
    test_target = hid("target:tests")
    project_id = hid("project")
    main_group = hid("group:main")
    products_group = hid("group:products")
    app_group = hid("group:app")
    tests_group = hid("group:tests")
    sources_phase_app = hid("phase:sources:app")
    sources_phase_tests = hid("phase:sources:tests")
    resources_phase_app = hid("phase:resources:app")
    frameworks_app = hid("phase:frameworks:app")
    frameworks_tests = hid("phase:frameworks:tests")
    app_product = hid("product:app")
    test_product = hid("product:tests")
    proj_configs = hid("configs:project")
    app_configs = hid("configs:app")
    test_configs = hid("configs:tests")
    proj_debug = hid("config:project:debug")
    proj_release = hid("config:project:release")
    app_debug = hid("config:app:debug")
    app_release = hid("config:app:release")
    test_debug = hid("config:tests:debug")
    test_release = hid("config:tests:release")
    container_proxy = hid("proxy:tests")
    target_dep = hid("dep:tests->app")

    file_refs = []
    build_files_sources = []
    build_files_resources = []
    build_files_tests = []

    for path in SWIFT_SOURCES:
        name = Path(path).name
        ref = hid(f"fileref:{path}")
        build = hid(f"build:{path}")
        file_refs.append(
            f"\t\t{ref} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {name}; sourceTree = \"<group>\"; }};"
        )
        build_files_sources.append(
            f"\t\t{build} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {ref} /* {name} */; }};"
        )

    assets_ref = hid("fileref:UmrahGuide/Resources/Assets.xcassets")
    privacy_ref = hid("fileref:UmrahGuide/Resources/PrivacyInfo.xcprivacy")
    file_refs.append(
        f"\t\t{assets_ref} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = \"<group>\"; }};"
    )
    file_refs.append(
        f"\t\t{privacy_ref} /* PrivacyInfo.xcprivacy */ = {{isa = PBXFileReference; lastKnownFileType = text.xml; path = PrivacyInfo.xcprivacy; sourceTree = \"<group>\"; }};"
    )
    build_files_resources.append(
        f"\t\t{hid('build:UmrahGuide/Resources/Assets.xcassets')} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {assets_ref} /* Assets.xcassets */; }};"
    )
    build_files_resources.append(
        f"\t\t{hid('build:UmrahGuide/Resources/PrivacyInfo.xcprivacy')} /* PrivacyInfo.xcprivacy in Resources */ = {{isa = PBXBuildFile; fileRef = {privacy_ref} /* PrivacyInfo.xcprivacy */; }};"
    )

    for path in TESTS:
        name = Path(path).name
        ref = hid(f"fileref:{path}")
        build = hid(f"build:{path}")
        file_refs.append(
            f"\t\t{ref} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {name}; sourceTree = \"<group>\"; }};"
        )
        build_files_tests.append(
            f"\t\t{build} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {ref} /* {name} */; }};"
        )

    file_refs.append(
        f"\t\t{app_product} /* UmrahGuide.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = UmrahGuide.app; sourceTree = BUILT_PRODUCTS_DIR; }};"
    )
    file_refs.append(
        f"\t\t{test_product} /* UmrahGuideTests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = UmrahGuideTests.xctest; sourceTree = BUILT_PRODUCTS_DIR; }};"
    )

    def nested_groups() -> str:
        # Build a tree from SWIFT_SOURCES + resources under UmrahGuide/
        tree: dict = {}

        def add(rel: str, is_file: bool = True):
            parts = Path(rel).parts
            node = tree
            for part in parts[:-1]:
                node = node.setdefault(part, {})
            node[parts[-1]] = rel if is_file else {}

        for p in SWIFT_SOURCES + RESOURCES:
            add(p)

        groups = []

        def emit(folder: str, node: dict, parent_key: str) -> str:
            gid = hid(f"group:{parent_key}")
            children = []
            for name in sorted(node.keys(), key=lambda n: (isinstance(node[n], str), n.lower())):
                value = node[name]
                if isinstance(value, str):
                    children.append(f"\t\t\t\t{hid(f'fileref:{value}')} /* {name} */,")
                else:
                    child_id = emit(name, value, f"{parent_key}/{name}")
                    children.append(f"\t\t\t\t{child_id} /* {name} */,")
            groups.append(
                f"\t\t{gid} /* {folder} */ = {{\n"
                f"\t\t\tisa = PBXGroup;\n"
                f"\t\t\tchildren = (\n"
                + "\n".join(children)
                + "\n\t\t\t);\n"
                f"\t\t\tpath = {json.dumps(folder) if not folder.isidentifier() else folder};\n"
                f'\t\t\tsourceTree = "<group>";\n'
                f"\t\t}};"
            )
            return gid

        umrah_id = emit("UmrahGuide", tree["UmrahGuide"], "UmrahGuide")
        return umrah_id, "\n".join(groups)

    app_group_id, nested = nested_groups()

    test_child_lines = "\n".join(
        f"\t\t\t\t{hid(f'fileref:{p}')} /* {Path(p).name} */," for p in TESTS
    )

    source_build_list = "\n".join(
        f"\t\t\t\t{hid(f'build:{p}')} /* {Path(p).name} in Sources */," for p in SWIFT_SOURCES
    )
    resource_build_list = "\n".join(
        f"\t\t\t\t{hid(f'build:{p}')} /* {Path(p).name} in Resources */," for p in RESOURCES
    )
    test_build_list = "\n".join(
        f"\t\t\t\t{hid(f'build:{p}')} /* {Path(p).name} in Sources */," for p in TESTS
    )

    objects = []
    objects.append("/* Begin PBXBuildFile section */")
    objects.extend(build_files_sources)
    objects.extend(build_files_resources)
    objects.extend(build_files_tests)
    objects.append("/* End PBXBuildFile section */\n")

    objects.append("/* Begin PBXContainerItemProxy section */")
    objects.append(
        f"\t\t{container_proxy} /* PBXContainerItemProxy */ = {{\n"
        f"\t\t\tisa = PBXContainerItemProxy;\n"
        f"\t\t\tcontainerPortal = {project_id} /* Project object */;\n"
        f"\t\t\tproxyType = 1;\n"
        f"\t\t\tremoteGlobalIDString = {app_target};\n"
        f"\t\t\tremoteInfo = UmrahGuide;\n"
        f"\t\t}};"
    )
    objects.append("/* End PBXContainerItemProxy section */\n")

    objects.append("/* Begin PBXFileReference section */")
    objects.extend(file_refs)
    objects.append("/* End PBXFileReference section */\n")

    objects.append("/* Begin PBXFrameworksBuildPhase section */")
    objects.append(
        f"\t\t{frameworks_app} /* Frameworks */ = {{\n"
        f"\t\t\tisa = PBXFrameworksBuildPhase;\n"
        f"\t\t\tbuildActionMask = 2147483647;\n"
        f"\t\t\tfiles = (\n"
        f"\t\t\t);\n"
        f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        f"\t\t}};"
    )
    objects.append(
        f"\t\t{frameworks_tests} /* Frameworks */ = {{\n"
        f"\t\t\tisa = PBXFrameworksBuildPhase;\n"
        f"\t\t\tbuildActionMask = 2147483647;\n"
        f"\t\t\tfiles = (\n"
        f"\t\t\t);\n"
        f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        f"\t\t}};"
    )
    objects.append("/* End PBXFrameworksBuildPhase section */\n")

    objects.append("/* Begin PBXGroup section */")
    objects.append(
        f"\t\t{main_group} = {{\n"
        f"\t\t\tisa = PBXGroup;\n"
        f"\t\t\tchildren = (\n"
        f"\t\t\t\t{app_group_id} /* UmrahGuide */,\n"
        f"\t\t\t\t{tests_group} /* UmrahGuideTests */,\n"
        f"\t\t\t\t{products_group} /* Products */,\n"
        f"\t\t\t);\n"
        f'\t\t\tsourceTree = "<group>";\n'
        f"\t\t}};"
    )
    objects.append(
        f"\t\t{products_group} /* Products */ = {{\n"
        f"\t\t\tisa = PBXGroup;\n"
        f"\t\t\tchildren = (\n"
        f"\t\t\t\t{app_product} /* UmrahGuide.app */,\n"
        f"\t\t\t\t{test_product} /* UmrahGuideTests.xctest */,\n"
        f"\t\t\t);\n"
        f"\t\t\tname = Products;\n"
        f'\t\t\tsourceTree = "<group>";\n'
        f"\t\t}};"
    )
    objects.append(
        f"\t\t{tests_group} /* UmrahGuideTests */ = {{\n"
        f"\t\t\tisa = PBXGroup;\n"
        f"\t\t\tchildren = (\n"
        f"{test_child_lines}\n"
        f"\t\t\t);\n"
        f"\t\t\tpath = UmrahGuideTests;\n"
        f'\t\t\tsourceTree = "<group>";\n'
        f"\t\t}};"
    )
    objects.append(nested)
    objects.append("/* End PBXGroup section */\n")

    objects.append("/* Begin PBXNativeTarget section */")
    objects.append(
        f"\t\t{app_target} /* UmrahGuide */ = {{\n"
        f"\t\t\tisa = PBXNativeTarget;\n"
        f"\t\t\tbuildConfigurationList = {app_configs} /* Build configuration list for PBXNativeTarget \"UmrahGuide\" */;\n"
        f'\t\t\tbuildPhases = (\n'
        f"\t\t\t\t{sources_phase_app} /* Sources */,\n"
        f"\t\t\t\t{frameworks_app} /* Frameworks */,\n"
        f"\t\t\t\t{resources_phase_app} /* Resources */,\n"
        f"\t\t\t);\n"
        f"\t\t\tbuildRules = (\n"
        f"\t\t\t);\n"
        f"\t\t\tdependencies = (\n"
        f"\t\t\t);\n"
        f"\t\t\tname = UmrahGuide;\n"
        f"\t\t\tproductName = UmrahGuide;\n"
        f"\t\t\tproductReference = {app_product} /* UmrahGuide.app */;\n"
        f"\t\t\tproductType = \"com.apple.product-type.application\";\n"
        f"\t\t}};"
    )
    objects.append(
        f"\t\t{test_target} /* UmrahGuideTests */ = {{\n"
        f"\t\t\tisa = PBXNativeTarget;\n"
        f"\t\t\tbuildConfigurationList = {test_configs} /* Build configuration list for PBXNativeTarget \"UmrahGuideTests\" */;\n"
        f"\t\t\tbuildPhases = (\n"
        f"\t\t\t\t{sources_phase_tests} /* Sources */,\n"
        f"\t\t\t\t{frameworks_tests} /* Frameworks */,\n"
        f"\t\t\t);\n"
        f"\t\t\tbuildRules = (\n"
        f"\t\t\t);\n"
        f"\t\t\tdependencies = (\n"
        f"\t\t\t\t{target_dep} /* PBXTargetDependency */,\n"
        f"\t\t\t);\n"
        f"\t\t\tname = UmrahGuideTests;\n"
        f"\t\t\tproductName = UmrahGuideTests;\n"
        f"\t\t\tproductReference = {test_product} /* UmrahGuideTests.xctest */;\n"
        f"\t\t\tproductType = \"com.apple.product-type.bundle.unit-test\";\n"
        f"\t\t}};"
    )
    objects.append("/* End PBXNativeTarget section */\n")

    objects.append("/* Begin PBXProject section */")
    objects.append(
        f"\t\t{project_id} /* Project object */ = {{\n"
        f"\t\t\tisa = PBXProject;\n"
        f"\t\t\tattributes = {{\n"
        f"\t\t\t\tBuildIndependentTargetsInParallel = 1;\n"
        f"\t\t\t\tLastSwiftUpdateCheck = 1500;\n"
        f"\t\t\t\tLastUpgradeCheck = 1500;\n"
        f"\t\t\t\tTargetAttributes = {{\n"
        f"\t\t\t\t\t{app_target} = {{\n"
        f"\t\t\t\t\t\tCreatedOnToolsVersion = 15.0;\n"
        f"\t\t\t\t\t}};\n"
        f"\t\t\t\t\t{test_target} = {{\n"
        f"\t\t\t\t\t\tCreatedOnToolsVersion = 15.0;\n"
        f"\t\t\t\t\t\tTestTargetID = {app_target};\n"
        f"\t\t\t\t\t}};\n"
        f"\t\t\t\t}};\n"
        f"\t\t\t}};\n"
        f"\t\t\tbuildConfigurationList = {proj_configs} /* Build configuration list for PBXProject \"UmrahGuide\" */;\n"
        f'\t\t\tcompatibilityVersion = "Xcode 15.0";\n'
        f"\t\t\tdevelopmentRegion = en;\n"
        f"\t\t\thasScannedForEncodings = 0;\n"
        f"\t\t\tknownRegions = (\n"
        f"\t\t\t\ten,\n"
        f"\t\t\t\tBase,\n"
        f"\t\t\t);\n"
        f"\t\t\tmainGroup = {main_group};\n"
        f"\t\t\tproductRefGroup = {products_group} /* Products */;\n"
        f'\t\t\tprojectDirPath = "";\n'
        f'\t\t\tprojectRoot = "";\n'
        f"\t\t\ttargets = (\n"
        f"\t\t\t\t{app_target} /* UmrahGuide */,\n"
        f"\t\t\t\t{test_target} /* UmrahGuideTests */,\n"
        f"\t\t\t);\n"
        f"\t\t}};"
    )
    objects.append("/* End PBXProject section */\n")

    objects.append("/* Begin PBXResourcesBuildPhase section */")
    objects.append(
        f"\t\t{resources_phase_app} /* Resources */ = {{\n"
        f"\t\t\tisa = PBXResourcesBuildPhase;\n"
        f"\t\t\tbuildActionMask = 2147483647;\n"
        f"\t\t\tfiles = (\n"
        f"{resource_build_list}\n"
        f"\t\t\t);\n"
        f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        f"\t\t}};"
    )
    objects.append("/* End PBXResourcesBuildPhase section */\n")

    objects.append("/* Begin PBXSourcesBuildPhase section */")
    objects.append(
        f"\t\t{sources_phase_app} /* Sources */ = {{\n"
        f"\t\t\tisa = PBXSourcesBuildPhase;\n"
        f"\t\t\tbuildActionMask = 2147483647;\n"
        f"\t\t\tfiles = (\n"
        f"{source_build_list}\n"
        f"\t\t\t);\n"
        f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        f"\t\t}};"
    )
    objects.append(
        f"\t\t{sources_phase_tests} /* Sources */ = {{\n"
        f"\t\t\tisa = PBXSourcesBuildPhase;\n"
        f"\t\t\tbuildActionMask = 2147483647;\n"
        f"\t\t\tfiles = (\n"
        f"{test_build_list}\n"
        f"\t\t\t);\n"
        f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        f"\t\t}};"
    )
    objects.append("/* End PBXSourcesBuildPhase section */\n")

    objects.append("/* Begin PBXTargetDependency section */")
    objects.append(
        f"\t\t{target_dep} /* PBXTargetDependency */ = {{\n"
        f"\t\t\tisa = PBXTargetDependency;\n"
        f"\t\t\ttarget = {app_target} /* UmrahGuide */;\n"
        f"\t\t\ttargetProxy = {container_proxy} /* PBXContainerItemProxy */;\n"
        f"\t\t}};"
    )
    objects.append("/* End PBXTargetDependency section */\n")

    def xc_config(ident: str, name: str, pairs: dict[str, str]) -> str:
        return (
            f"\t\t{ident} /* {name} */ = {{\n"
            f"\t\t\tisa = XCBuildConfiguration;\n"
            f"\t\t\tbuildSettings = {{\n"
            f"{settings_block(pairs)}\n"
            f"\t\t\t}};\n"
            f"\t\t\tname = {name};\n"
            f"\t\t}};"
        )

    objects.append("/* Begin XCBuildConfiguration section */")
    objects.append(xc_config(proj_debug, "Debug", COMMON_DEBUG))
    objects.append(xc_config(proj_release, "Release", COMMON_RELEASE))
    objects.append(xc_config(app_debug, "Debug", APP_KEYS))
    objects.append(xc_config(app_release, "Release", APP_KEYS))
    objects.append(xc_config(test_debug, "Debug", TEST_KEYS))
    objects.append(xc_config(test_release, "Release", TEST_KEYS))
    objects.append("/* End XCBuildConfiguration section */\n")

    def xc_list(ident: str, title: str, debug: str, release: str) -> str:
        return (
            f"\t\t{ident} /* {title} */ = {{\n"
            f"\t\t\tisa = XCConfigurationList;\n"
            f"\t\t\tbuildConfigurations = (\n"
            f"\t\t\t\t{debug} /* Debug */,\n"
            f"\t\t\t\t{release} /* Release */,\n"
            f"\t\t\t);\n"
            f"\t\t\tdefaultConfigurationIsVisible = 0;\n"
            f"\t\t\tdefaultConfigurationName = Release;\n"
            f"\t\t}};"
        )

    objects.append("/* Begin XCConfigurationList section */")
    objects.append(xc_list(proj_configs, 'Build configuration list for PBXProject "UmrahGuide"', proj_debug, proj_release))
    objects.append(xc_list(app_configs, 'Build configuration list for PBXNativeTarget "UmrahGuide"', app_debug, app_release))
    objects.append(xc_list(test_configs, 'Build configuration list for PBXNativeTarget "UmrahGuideTests"', test_debug, test_release))
    objects.append("/* End XCConfigurationList section */")

    body = (
        "// !$*UTF8*$!\n"
        "{\n"
        "\tarchiveVersion = 1;\n"
        "\tclasses = {\n"
        "\t};\n"
        "\tobjectVersion = 56;\n"
        "\tobjects = {\n\n"
        + "\n".join(objects)
        + "\n\t};\n"
        f"\trootObject = {project_id} /* Project object */;\n"
        "}\n"
    )

    PROJECT.mkdir(parents=True, exist_ok=True)
    (PROJECT / "project.pbxproj").write_text(body)

    workspace = PROJECT / "project.xcworkspace"
    workspace.mkdir(parents=True, exist_ok=True)
    (workspace / "contents.xcworkspacedata").write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Workspace\n'
        '   version = "1.0">\n'
        '   <FileRef\n'
        '      location = "self:">\n'
        '   </FileRef>\n'
        '</Workspace>\n'
    )

    scheme_dir = PROJECT / "xcshareddata" / "xcschemes"
    scheme_dir.mkdir(parents=True, exist_ok=True)
    (scheme_dir / "UmrahGuide.xcscheme").write_text(
        f"""<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "{app_target}"
               BuildableName = "UmrahGuide.app"
               BlueprintName = "UmrahGuide"
               ReferencedContainer = "container:UmrahGuide.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES"
      shouldAutocreateTestPlan = "YES">
      <Testables>
         <TestableReference
            skipped = "NO"
            parallelizable = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "{test_target}"
               BuildableName = "UmrahGuideTests.xctest"
               BlueprintName = "UmrahGuideTests"
               ReferencedContainer = "container:UmrahGuide.xcodeproj">
            </BuildableReference>
         </TestableReference>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "NO">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{app_target}"
            BuildableName = "UmrahGuide.app"
            BlueprintName = "UmrahGuide"
            ReferencedContainer = "container:UmrahGuide.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{app_target}"
            BuildableName = "UmrahGuide.app"
            BlueprintName = "UmrahGuide"
            ReferencedContainer = "container:UmrahGuide.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
"""
    )
    print(f"Wrote {PROJECT}")


def main() -> None:
    write_assets()
    write_project()
    missing = [p for p in SWIFT_SOURCES + RESOURCES + TESTS if not (ROOT / p).exists() and not (ROOT / p).is_dir()]
    # assets dir created by write_assets
    missing = [p for p in SWIFT_SOURCES + TESTS if not (ROOT / p).exists()]
    if missing:
        raise SystemExit(f"Missing source files: {missing}")
    print("Project files verified.")


if __name__ == "__main__":
    main()
