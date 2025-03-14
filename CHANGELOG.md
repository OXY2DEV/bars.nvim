# Changelog

## [2.0.1](https://github.com/OXY2DEV/bars.nvim/compare/v2.0.0...v2.0.1) (2025-03-14)


### Bug Fixes

* Changed file names due to character restrictions on Windows(& MacOS) ([3729d8c](https://github.com/OXY2DEV/bars.nvim/commit/3729d8cf218ade8a34cf4d7f018515185329bb90)), closes [#4](https://github.com/OXY2DEV/bars.nvim/issues/4)

## [2.0.0](https://github.com/OXY2DEV/bars.nvim/compare/v1.0.0...v2.0.0) (2025-03-14)


### ⚠ BREAKING CHANGES

* Changed internal name from `part` to `component`

### Features

* Added ability to disable modules with `setup()` ([db076b4](https://github.com/OXY2DEV/bars.nvim/commit/db076b4ffa509aace45c57d7a165ee59a1c79c49))
* **core:** Added a `global_attach()` functions ([09ba2e0](https://github.com/OXY2DEV/bars.nvim/commit/09ba2e0e84d17907a776a10d34a7639f599ea0dd))
* **core:** Added ability to update different bars & lines on filetype ([1b59ff5](https://github.com/OXY2DEV/bars.nvim/commit/1b59ff5bfe19203f575eb3ee94f3c57a95f09113))
* **core:** Added actions for the plugin ([900bc9d](https://github.com/OXY2DEV/bars.nvim/commit/900bc9d03d852549ccb4fd73dd22c664c7df78f3))
* **core:** Added command support. ([2e11413](https://github.com/OXY2DEV/bars.nvim/commit/2e114131dd15c602dec63d11f41944c7de367f4f))
* **core:** Added custom section/column support ([8a76c1b](https://github.com/OXY2DEV/bars.nvim/commit/8a76c1b69e54e717643dc55c80a0a235057c89be))
* **core:** Added sub-module configuration via `bars.setup()` ([1165c50](https://github.com/OXY2DEV/bars.nvim/commit/1165c501f60f505999c89f744fe2a0d3cbad1840))
* **core:** Added support for dynamic values in `bars.setup()` ([c5d61d0](https://github.com/OXY2DEV/bars.nvim/commit/c5d61d0366e905575fb4111003ea0552cedcdecb))
* **core:** Mode changes now update the bars & lines ([909ba6c](https://github.com/OXY2DEV/bars.nvim/commit/909ba6c4ddf2af70f5217fe5b301c6f050c2d489))
* **global:** Added functions to scroll through tab list ([f433250](https://github.com/OXY2DEV/bars.nvim/commit/f433250f88a5cedd44b4132d3a9e03d8b364c71d))
* **statuscolumn:** Added ability to Toggle statuscolumn ([6133947](https://github.com/OXY2DEV/bars.nvim/commit/6133947bc23243668c0fbc754184601bdda0aa02))
* **statuscolumn:** Added click support for lnum ([de3c702](https://github.com/OXY2DEV/bars.nvim/commit/de3c70293edb96cf1730b9de3462ea22fc70406a))
* **statuscolumn:** Added Enabling & Disabling commands ([6c26f92](https://github.com/OXY2DEV/bars.nvim/commit/6c26f92c4dfa9b7e93063adbe94caae73ba36234))
* **statuscolumn:** Added filter support for signs ([2369dcf](https://github.com/OXY2DEV/bars.nvim/commit/2369dcf02bc882551bb36db126df1043cb33527b))
* **statusline:** Added ability to Toggle statusline ([cc1931f](https://github.com/OXY2DEV/bars.nvim/commit/cc1931fe2a0267f7b87e8eaa94568ffaab0eab22))
* **statusline:** Added detached HEAD branch support ([feecfa0](https://github.com/OXY2DEV/bars.nvim/commit/feecfa0de0d56701322f2551db66c5fd9134573f))
* **statusline:** Added Enable & Disable function ([4d68f88](https://github.com/OXY2DEV/bars.nvim/commit/4d68f8802f2aae8bcd2d03d9102515b39b7338ca))
* **statusline:** Help window's statusline now shows the ruler in Visual ([37e819f](https://github.com/OXY2DEV/bars.nvim/commit/37e819fa6f972fe85fc6bed131e243afd612fd09))
* **tabline:** Added a tab list for the tabline ([339b0bb](https://github.com/OXY2DEV/bars.nvim/commit/339b0bb297673e4368bca4d9440f68fc2e7ff6cd))
* **tabline:** Added ability to Toggle tabline ([404dfb0](https://github.com/OXY2DEV/bars.nvim/commit/404dfb0aacac1d5ff5c716ea44211fd2b554e1fe))
* **tabline:** Added buffer list part ([8c43622](https://github.com/OXY2DEV/bars.nvim/commit/8c43622ff2604da1b9229fd4227a097888461736))
* **tabline:** Added current bufname support for tabline ([0bd5395](https://github.com/OXY2DEV/bars.nvim/commit/0bd5395bbf600c0bef2e05e468a28be18208cedb))
* **tabline:** Added Enable & Disable functions ([8065320](https://github.com/OXY2DEV/bars.nvim/commit/8065320ed8ffb6e9f3ac09b6735a16075934a80a))
* **tabline:** Added tabline component to show tabs ([5b42f8e](https://github.com/OXY2DEV/bars.nvim/commit/5b42f8ede6594f8992719f88568a8aaf308353ff))
* **tabline:** Added tabpage list locking ([a0d03ec](https://github.com/OXY2DEV/bars.nvim/commit/a0d03ece2db249068f30c160545594e17faa7990))
* **winbar:** Added ability to Toggle winbar ([2d5de92](https://github.com/OXY2DEV/bars.nvim/commit/2d5de92158e971924b38e237c01eb5c1cc6b91db))
* **winbar:** Added Enable & Disable functions ([18d43b2](https://github.com/OXY2DEV/bars.nvim/commit/18d43b28d3c16d98b1f2ee955c9f8d4d5839ba0e))
* **winbar:** Added file path support for winbar ([f938cf5](https://github.com/OXY2DEV/bars.nvim/commit/f938cf59c4564848ba5f2e355ff1a3d5cec03c0d))
* **winbar:** Added lua_patterns support ([65a4340](https://github.com/OXY2DEV/bars.nvim/commit/65a4340437bc521092dde9ef1acf4b8b8d51f523))
* **winbar:** Added new winbar ([da5a456](https://github.com/OXY2DEV/bars.nvim/commit/da5a4560f9ba426855b3d2c594a4f9e4c6e30283))
* **winbar:** LuaDoc support ([7396456](https://github.com/OXY2DEV/bars.nvim/commit/73964561eb3ab8a5919be9b89e642354139779b6))


### Bug Fixes

* Added background to BarsLineNr ([237ff67](https://github.com/OXY2DEV/bars.nvim/commit/237ff67b103c5678c1976157520bcafcb5ccd84f))
* Added window validity check for statusline detaching ([17ecf91](https://github.com/OXY2DEV/bars.nvim/commit/17ecf9137bafef1199878bd6099db72d8a26a2a4))
* **core:** Fixed a bug with `setup()` not causing the cached IDs to update ([24b92af](https://github.com/OXY2DEV/bars.nvim/commit/24b92afbcbe04a3efa8780b05a359493158b8a29))
* **core:** Fixed how toggling of modules work ([4a8cdd6](https://github.com/OXY2DEV/bars.nvim/commit/4a8cdd6a62d81354c29667ed2fa4752156293f46))
* **core:** setup() now gets called when loading this plugin ([500245f](https://github.com/OXY2DEV/bars.nvim/commit/500245f462d6d912a9169a958cf52f4fac3f2df5))
* Finished adding remaining highlight groups ([cf6a4c8](https://github.com/OXY2DEV/bars.nvim/commit/cf6a4c8955b10c5aa92787630c6605deeec7b853))
* **statuscolumn:** `relativenumber` & `numberwidth` are now applied with ([8dcbf60](https://github.com/OXY2DEV/bars.nvim/commit/8dcbf60e7fe1856e0701b10dc1f8756e971a0a15))
* **statuscolumn:** Added check for module state before attching to new buffer ([6c26f92](https://github.com/OXY2DEV/bars.nvim/commit/6c26f92c4dfa9b7e93063adbe94caae73ba36234))
* **statuscolumn:** Changed when options are set ([e801a2d](https://github.com/OXY2DEV/bars.nvim/commit/e801a2d5a4e0031374a656dd46b4e188531f2675))
* **statuscolumn:** Fixed a bug with errors when trying to detach from invalid windows ([1d5ab23](https://github.com/OXY2DEV/bars.nvim/commit/1d5ab238fc77465f142e5325c1bc77a74a26d484))
* **statuscolumn:** Fixed incorrect fold marker on the last line of a buffer ([607a208](https://github.com/OXY2DEV/bars.nvim/commit/607a20802d5aa2c237116c266307053d1c0054b2))
* **statuscolumn:** Fold column no longer shows incorrect symbol on final buffer line ([d6cd485](https://github.com/OXY2DEV/bars.nvim/commit/d6cd485618bb2ba34a7960b5e377bcea3b67978b))
* **statuscolumn:** Global statuscolumn now gets cached too ([338985b](https://github.com/OXY2DEV/bars.nvim/commit/338985b9a361f33b5b0cb89361cbe3fcd5b57913))
* **statuscolumn:** List values now get properly applied for folds ([3a4c93f](https://github.com/OXY2DEV/bars.nvim/commit/3a4c93f1889690fdf792070225ce29770d45b035))
* **statuscolumn:** No longer detach from windows that weren't attached ([1d5ab23](https://github.com/OXY2DEV/bars.nvim/commit/1d5ab238fc77465f142e5325c1bc77a74a26d484))
* **statusline:** Calling `statusline.toggle()` no longer toggles it globally(when the cached value is "" or nil) ([34ee471](https://github.com/OXY2DEV/bars.nvim/commit/34ee471b7f02c41f38e3a885271800c7aeaf6602))
* **statusline:** Chnaged when statusline is set ([2d117bd](https://github.com/OXY2DEV/bars.nvim/commit/2d117bd9ca6314d36fb0c42a04f9cd605394e90e))
* **statusline:** Diagnoatics are now shown per buffer ([339a4ca](https://github.com/OXY2DEV/bars.nvim/commit/339a4ca80556e8427f9ef9b9a49817fdf0ce63a0))
* **statusline:** Fixdd issues with detaching from attached buffers ([d924e1a](https://github.com/OXY2DEV/bars.nvim/commit/d924e1a1d0d8b8273977eda7161698f2353a4676))
* **statusline:** Fixed a bug with `ignore_*` not being respected ([ede5576](https://github.com/OXY2DEV/bars.nvim/commit/ede55763c95c8001d742b511e7514dd5838a42c5))
* **statusline:** Fixed a bug with not getting a branch causing errors ([586e94a](https://github.com/OXY2DEV/bars.nvim/commit/586e94aa462a52c93b5a866b79e148a287dca690))
* **statusline:** Fixed issues with detaching from attached buffers ([d924e1a](https://github.com/OXY2DEV/bars.nvim/commit/d924e1a1d0d8b8273977eda7161698f2353a4676))
* **statusline:** Statusline module's state is now checked before attaching to new windows ([80fc8d3](https://github.com/OXY2DEV/bars.nvim/commit/80fc8d36fae094ff1f9b79d935a8d93ce4f8eea4))
* **statusline:** Updated bufname icons ([680036b](https://github.com/OXY2DEV/bars.nvim/commit/680036bb248f3e8b15efeed2b8f8287c45f9295c))
* **tabline:** `setup()` no longer disables tabline ([043cae8](https://github.com/OXY2DEV/bars.nvim/commit/043cae8524d88ca2b30a8651db43b550abaab8c3))
* **tabline:** Fixed navigation function ([8c43622](https://github.com/OXY2DEV/bars.nvim/commit/8c43622ff2604da1b9229fd4227a097888461736))
* **winbar:** Fixed a big with the `node` part ([6834630](https://github.com/OXY2DEV/bars.nvim/commit/683463074a461887bf0b84055974c0cdbd122b3e))
* **winbar:** Winbar module's state is now checked before attaching to new windows ([ef9d737](https://github.com/OXY2DEV/bars.nvim/commit/ef9d737c62e86fac094b1ffa0f528a6776b805ee))
* **winbr:** Changed when winbar is set ([2d117bd](https://github.com/OXY2DEV/bars.nvim/commit/2d117bd9ca6314d36fb0c42a04f9cd605394e90e))


### Code Refactoring

* Changed internal name from `part` to `component` ([d0dcda9](https://github.com/OXY2DEV/bars.nvim/commit/d0dcda966825a9c010f5fbb7fc6419a14709dc10))
