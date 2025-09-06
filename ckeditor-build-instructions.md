CKEditor 5 Custom Build Instructions (for lesson_note)

Goal
- Produce a CKEditor 5 Classic (or custom) build that matches the CKEditor demo feature set used on https://ckeditor.com/ckeditor-5/demo/feature-rich/
- Place the built JS as `dist/js/ckeditor.js` in this project. `lesson_note.php` will prefer that local file and fall back to the CDN.

Recommended plugin list
- Essentials
  - Essentials
  - Paragraph
  - Bold
  - Italic
  - Underline
  - Strikethrough
  - Subscript
  - Superscript
  - RemoveFormat
  - Heading
  - Link
  - List (BulletedList, NumberedList)
  - TodoList
  - BlockQuote
  - Code
  - HorizontalLine

- Text styling
  - FontFamily
  - FontSize
  - FontColor
  - FontBackgroundColor
  - Highlight

- Tables
  - Table
  - TableToolbar
  - TableProperties
  - TableCellProperties

- Images & Media
  - Image
  - ImageToolbar
  - ImageCaption
  - ImageStyle
  - ImageResize
  - ImageUpload
  - MediaEmbed

- Insert & embed
  - InsertTable (via Table)
  - MediaEmbed

- Advanced
  - Alignment
  - Indent
  - CodeBlock
  - SpecialCharacters
  - ExportPdf (optional)

- Helpers
  - Autoformat
  - PasteFromOffice

Notes about plugin availability
- Not all plugins are available in the default CDN `classic` build. If you require exact parity with the demo, create a custom build that includes the above plugins.
- Image upload requires a server adapter. The build includes UI and features, but you must implement an upload adapter on the server (or use Base64 upload) to persist images.

How to create the custom build (two ways)

Option A — CKEditor 5 Online Builder (recommended for quick custom builds)
1. Visit: https://ckeditor.com/ckeditor-5/online-builder/
2. Choose the "Classic editor" template.
3. Select the plugins from the recommended list above (at least: Table, Image, ImageUpload, MediaEmbed, Font, FontColor, FontBackgroundColor, Alignment, TodoList).
4. Configure default toolbar order (the builder UI lets you pick and order items).
5. Download the generated build (ZIP).
6. Unzip and locate the build file, typically `build/ckeditor.js`.
7. Copy `ckeditor.js` into this project at `dist/js/ckeditor.js`.
8. Reload `lesson_note.php` — it will use the local build.

Option B — Build locally with npm (recommended for deeper customization)
1. Ensure Node.js and npm are installed.
2. Create a temporary folder (for example `ckeditor-build`) and initialize a new project:

```powershell
mkdir ckeditor-build; cd ckeditor-build
npm init -y
npm install --save @ckeditor/ckeditor5-build-classic
# For custom plugin inclusion, follow CKEditor docs to create a custom build repo instead of using the prebuilt package.
```

3. Follow the CKEditor 5 Custom Build guide: https://ckeditor.com/docs/ckeditor5/latest/builds/guides/development/custom-builds.html
4. After building (`npm run build` or the provided script), copy the produced `build/ckeditor.js` into `dist/js/ckeditor.js`.

Server-side image upload adapter
- If you include `ImageUpload` in the build, you must provide an upload adapter. See the guide:
  https://ckeditor.com/docs/ckeditor5/latest/features/image-upload/overview.html
- For a simple approach, use the Base64 upload adapter (adds images inline as base64). This is available as `@ckeditor/ckeditor5-upload/src/adapters/base64uploadadapter` — include it if you want zero-server-image-upload initially.

Toolbar suggestion (order)
- heading | fontFamily fontSize | bold italic underline strikethrough subscript superscript | fontColor fontBackgroundColor highlight | link | bulletedList numberedList todoList | outdent indent alignment | insertTable | imageUpload mediaEmbed | blockQuote code codeBlock | undo redo removeFormat

Final steps
- Put the built `ckeditor.js` at `dist/js/ckeditor.js`.
- Optionally copy the `styles` folder or CSS from the build if instructed by the builder.
- Verify `lesson_note.php` loads the local file (console will show it).

If you want, I can:
- Generate a ready-to-run `webpack` based custom build config here (but I cannot run npm build in this environment). I will provide step-by-step commands you can run locally to produce `dist/js/ckeditor.js`.
- Create a pared-down toolbar config if you prefer to keep the CDN build and only show available buttons.

Which would you like next?
- Provide the exact npm steps and files (webpack config, package.json snippets) to build locally, or
- Provide the full plugin list in CKEditor Online Builder friendly format and the toolbar definition to paste into the builder UI.