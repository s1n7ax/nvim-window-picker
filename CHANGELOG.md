# Changelog

## [2.3.1](https://github.com/s1n7ax/nvim-window-picker/compare/v2.3.0...v2.3.1) (2025-01-24)


### Bug Fixes

* resolve issue 101 ([#102](https://github.com/s1n7ax/nvim-window-picker/issues/102)) ([1deef6d](https://github.com/s1n7ax/nvim-window-picker/commit/1deef6d5caa6ac70bb5d819e51ecb5ec924ea1b2))

## [2.3.0](https://github.com/s1n7ax/nvim-window-picker/compare/v2.2.0...v2.3.0) (2025-01-14)


### Features

* add floating letter hint ([#99](https://github.com/s1n7ax/nvim-window-picker/issues/99)) ([bfe4976](https://github.com/s1n7ax/nvim-window-picker/commit/bfe49763dd297d02e5a9fda7ca252890324ef78e))

## [2.2.0](https://github.com/s1n7ax/nvim-window-picker/compare/v2.1.1...v2.2.0) (2025-01-11)


### Features

* add filter for snacks notifications ([#97](https://github.com/s1n7ax/nvim-window-picker/issues/97)) ([3639533](https://github.com/s1n7ax/nvim-window-picker/commit/3639533293f20b61c31c2d5a1167fd56dc5955ab))

## [2.1.1](https://github.com/s1n7ax/nvim-window-picker/compare/v2.1.0...v2.1.1) (2025-01-10)


### Bug Fixes

* **floating-big-letter:** correct padding and positioning ([#91](https://github.com/s1n7ax/nvim-window-picker/issues/91)) ([c9647c2](https://github.com/s1n7ax/nvim-window-picker/commit/c9647c256c4be5e82f4e01a53bedc78f64b86e27))
* invalid window id during restoring windows ([#89](https://github.com/s1n7ax/nvim-window-picker/issues/89)) ([fadf015](https://github.com/s1n7ax/nvim-window-picker/commit/fadf015ba4394ac04a0e02534c82e198f0c7e93d)), closes [#88](https://github.com/s1n7ax/nvim-window-picker/issues/88)

## [2.1.0](https://github.com/s1n7ax/nvim-window-picker/compare/v2.0.3...v2.1.0) (2025-01-09)


### Features

* add filter for unfocusable windows ([#90](https://github.com/s1n7ax/nvim-window-picker/issues/90)) ([1656a0a](https://github.com/s1n7ax/nvim-window-picker/commit/1656a0a03950f5be1a23146bbbd9f8dbf773a8a9))

## [2.0.3](https://github.com/s1n7ax/nvim-window-picker/compare/v2.0.1...v2.0.3) (2023-12-17)


### Features

* **rel:** add release-please version.txt ([82f9032](https://github.com/s1n7ax/nvim-window-picker/commit/82f90327d3ffddf3e28fa26d3aaf76c4d59f97e6))


### Bug Fixes

* error due to missing semicolon in big letters ([#77](https://github.com/s1n7ax/nvim-window-picker/issues/77)) ([f32f4f7](https://github.com/s1n7ax/nvim-window-picker/commit/f32f4f7b4d90fb4d6b3c513ae5329268019853d5))
* filter_func is not called ([#78](https://github.com/s1n7ax/nvim-window-picker/issues/78)) ([794fd5e](https://github.com/s1n7ax/nvim-window-picker/commit/794fd5e695035ee91e28bfec8d14b33777ecd18a))
* **floating-big-letter:** calculate max width ([#74](https://github.com/s1n7ax/nvim-window-picker/issues/74)) ([154b2c4](https://github.com/s1n7ax/nvim-window-picker/commit/154b2c4c2ea768f361e37ef5b4fd8144ad2634f9)), closes [#69](https://github.com/s1n7ax/nvim-window-picker/issues/69)
* nil error when backward compatibility highlights are set ([#79](https://github.com/s1n7ax/nvim-window-picker/issues/79)) ([7c936dd](https://github.com/s1n7ax/nvim-window-picker/commit/7c936ddc46cfdad18eefaa334bec952ce47d502b))
* No 2 is not displayed correctly in floating window ([#70](https://github.com/s1n7ax/nvim-window-picker/issues/70)) ([e7b6699](https://github.com/s1n7ax/nvim-window-picker/commit/e7b6699fbd007bbe61dc444734b9bade445b2984))
* release 2.0.2 in manifest ([b0eed25](https://github.com/s1n7ax/nvim-window-picker/commit/b0eed25e13eb5684ff59f1a679f48247965351be))
* release using default access token ([41c4677](https://github.com/s1n7ax/nvim-window-picker/commit/41c467731690d8d4a8b17c795cb14b63f1e53674))
* remove unwanted diagnostic disable comments ([886f541](https://github.com/s1n7ax/nvim-window-picker/commit/886f541cdf86d8190b1b64c98aeed817a49fb492))
* unwanted extra return ([#59](https://github.com/s1n7ax/nvim-window-picker/issues/59)) ([944c2fc](https://github.com/s1n7ax/nvim-window-picker/commit/944c2fca6656a4413de0ab6cad06c286ed1e44e9))


### Miscellaneous Chores

* release 2.0.3 ([06f2949](https://github.com/s1n7ax/nvim-window-picker/commit/06f29491a86a0f9f13bb6f3d862bd9dd844b4020))

## [2.0.2](https://github.com/s1n7ax/nvim-window-picker/compare/v2.0.1...v2.0.2) (2023-07-29)


### Bug Fixes

* respect global highlighting

## 2.0.0 (2023-06-21)


### ⚠ BREAKING CHANGES

* restructer pickers

### Features

* add ability to use winbar for selection ([df93ab7](https://github.com/s1n7ax/nvim-window-picker/commit/df93ab75b33409e0c2b9f1ee6d130d25e852cf3b))
* add compatibility to old config style ([5fca333](https://github.com/s1n7ax/nvim-window-picker/commit/5fca333a8ce640720b3d3225d2a8f16f0b0737ad))
* add demo videos ([3154cae](https://github.com/s1n7ax/nvim-window-picker/commit/3154cae12bfa3f85b57541a07907374066d1a517))
* add fg_color config option for setting text color ([aa36f61](https://github.com/s1n7ax/nvim-window-picker/commit/aa36f6172cb5f54e943b11c08383a2d1b369ef4a))
* add floating window picker ([a63245f](https://github.com/s1n7ax/nvim-window-picker/commit/a63245fed3af4aaddd78f20312081bd89fe56d3a))
* add hint specific config properties ([94d7d1e](https://github.com/s1n7ax/nvim-window-picker/commit/94d7d1e907bf9da254d356b4a7273f52842febed))
* add option "selection_display" to change display ([f80963b](https://github.com/s1n7ax/nvim-window-picker/commit/f80963bba37b2084d7770d6c83db3b74733a942b))
* add option "use_cmd" to show or not message in cmdline ([d65aaad](https://github.com/s1n7ax/nvim-window-picker/commit/d65aaade8e90d3e1ae443a3df2452dd54e7287bf))
* add statusline & winbar hint ([d645ac7](https://github.com/s1n7ax/nvim-window-picker/commit/d645ac7b3c0ea431ab1377b41bd2ede3a6086845))
* add support to big letter float from config ([722c2a4](https://github.com/s1n7ax/nvim-window-picker/commit/722c2a434f276fcfd0c350a78d48a2099a391a07))
* **dev:** add current win selector for dev testing ([78027ec](https://github.com/s1n7ax/nvim-window-picker/commit/78027ecfe33ad0b00b6dc71e1d6e0af636ff2986))
* **doc:** add a usage example ([d840ed3](https://github.com/s1n7ax/nvim-window-picker/commit/d840ed3c0e210f7b4eea046abc08e965a68daad3))
* **doc:** update read me to 2.0 ([195bb94](https://github.com/s1n7ax/nvim-window-picker/commit/195bb94c2e60be4beae8bfa47b267fe37ef51dc8))
* **doc:** update readme ([f2a0dd2](https://github.com/s1n7ax/nvim-window-picker/commit/f2a0dd2c110434ef474a287af8630c3421341aec))
* **doc:** update readme ([28c6790](https://github.com/s1n7ax/nvim-window-picker/commit/28c679060805d0861920d2277fd7191725dd6c20))
* init commit ([7b6c59f](https://github.com/s1n7ax/nvim-window-picker/commit/7b6c59f184ccc6c3ed330c12bafb75d86d7006db))


### Bug Fixes

* builder does not set the default values if custom is not passed ([7404d4f](https://github.com/s1n7ax/nvim-window-picker/commit/7404d4fdb6aad1945d0a6e1fe5793ea2d0b8977c))
* **doc:** fix plugin tag name ([a653009](https://github.com/s1n7ax/nvim-window-picker/commit/a653009beaa24d804b95c0f703974bbcda31820a))
* **doc:** fix readme ([fe71d0a](https://github.com/s1n7ax/nvim-window-picker/commit/fe71d0a76b2eb97551290e8b9f5a4e29598afc5e))
* enable configuration through setup call ([#37](https://github.com/s1n7ax/nvim-window-picker/issues/37)) ([c6b343b](https://github.com/s1n7ax/nvim-window-picker/commit/c6b343b8b4083f490b48ab9c87c8f15de5e9fade))
* error thrown when window is not available [#4](https://github.com/s1n7ax/nvim-window-picker/issues/4) ([8c3bdb5](https://github.com/s1n7ax/nvim-window-picker/commit/8c3bdb5ee3200285b1851a18fcf726242b23904f))
* fix all curr win adding up to config ([2d749f1](https://github.com/s1n7ax/nvim-window-picker/commit/2d749f1c5687511f22b827915fcfd48ba5ab2481))
* fix formatting and linting ([#40](https://github.com/s1n7ax/nvim-window-picker/issues/40)) ([0bb349b](https://github.com/s1n7ax/nvim-window-picker/commit/0bb349bcded0093d074f9a80a3607f631b58b733))
* fix invalid config access in pick_window() ([230589b](https://github.com/s1n7ax/nvim-window-picker/commit/230589bceed409f09a3d58f579a8122d43760ef7))
* fix window not highlighting issue ([1c84e48](https://github.com/s1n7ax/nvim-window-picker/commit/1c84e481082f59b038c97853becea1c868c149e0))
* floating windows shouldn't count as selectable ([588caa5](https://github.com/s1n7ax/nvim-window-picker/commit/588caa5762293e02aa9d64f8fd9bf6a6589d95cf))
* highlight not modifiable ([#27](https://github.com/s1n7ax/nvim-window-picker/issues/27)) ([65bbc52](https://github.com/s1n7ax/nvim-window-picker/commit/65bbc52c27b0cd4b29976fe03be73cc943357528))
* limit window selection to current tab ([9f113d6](https://github.com/s1n7ax/nvim-window-picker/commit/9f113d66623f59fb231a41f8282cbf47e5efb212))
* make floating windows work with input char native fn ([4dc0cd7](https://github.com/s1n7ax/nvim-window-picker/commit/4dc0cd74e65029ae26a545bf936ef56a9924a189))
* Not enough space when trying to set winbar ([bed6555](https://github.com/s1n7ax/nvim-window-picker/commit/bed65551aa0ea017c355bee6c4176d3e56c7cc0c))
* pick window is shown when no windows to hint ([ca789c7](https://github.com/s1n7ax/nvim-window-picker/commit/ca789c75b66f3c687a8137f3d51f3d776fa9746b))
* picker is not visible when cmdheight=0 ([8f5447f](https://github.com/s1n7ax/nvim-window-picker/commit/8f5447f2e3a1d2a57cdaabc43be62cec774035ba))
* unable to change mode select win or startus bar when default is false ([8e4a314](https://github.com/s1n7ax/nvim-window-picker/commit/8e4a314969a75a780b37034a973ac71f2517d315))
* update default `filter_rules` ([92be3fe](https://github.com/s1n7ax/nvim-window-picker/commit/92be3fe8c968f5056697a4c3e284a44632501b48))
* use new property values from use_winbar ([a53a3b7](https://github.com/s1n7ax/nvim-window-picker/commit/a53a3b7487a9f090f5405ead8dcd5ebf5b934e97))


### Code Refactoring

* restructer pickers ([aa21eb6](https://github.com/s1n7ax/nvim-window-picker/commit/aa21eb6519fd1edcb1f02f9cf17c0f2e13ed79a1))


### Miscellaneous Chores

* release 2.0.0 ([0adaad4](https://github.com/s1n7ax/nvim-window-picker/commit/0adaad479efcc1f9cf855f3f064d7b89f5d6e968))
