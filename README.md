# LocalizeKit

**LocalizeKit** is a powerful command-line tool that automates the localization of Flutter applications using AI-powered translation services. It processes ARB (Application Resource Bundle) files and generates accurate translations while preserving metadata, placeholders, and formatting.

## 🚀 Features

- **AI-Powered Translation**: Supports multiple AI models including Gemini 2.0 Flash, GPT-3.5 Turbo, and DeepSeek
- **Batch Processing**: Efficiently translates multiple strings in batches to optimize API usage
- **Smart Caching**: Tracks changes and only translates new or modified strings
- **Metadata Preservation**: Maintains ARB metadata and placeholders (`{count}`, `{name}`, etc.)
- **Duplicate Detection**: Automatically detects and removes duplicate entries
- **Flexible Output**: Supports custom output directories
- **Rich Logging**: Provides detailed progress tracking and error reporting
- **Multiple Languages**: Translate to multiple target languages simultaneously

## 📦 Installation

### Prerequisites

- Dart SDK 3.0.0 or higher
- API key for your preferred AI service (Gemini, OpenAI, or DeepSeek)

### Global Installation

```bash
dart pub global activate localize_kit
```

### Local Installation

```bash
git clone <repository-url>
cd localize_kit
dart pub get
```

## 🔧 Setup

### Environment Variables

Create a `.env` file in your project root and add your API key:

```env
# For Gemini 2.0 Flash (default)
GEMINI_API_KEY=your_gemini_api_key_here
```

### Get Your API Keys

- **Gemini**: Visit [Google AI Studio](https://aistudio.google.com/app/apikey)

## 🛠️ Usage

### Basic Usage

```bash
# Translate to multiple languages
dart run localize_kit -i lib/l10n/app_en.arb -l fr,de,es,hi

# Use custom output directory
dart run localize_kit -i lib/l10n/app_en.arb -l fr,de,es -o translations/

# Enable verbose logging
dart run localize_kit -i lib/l10n/app_en.arb -l fr,de,es -v
```

### Command Line Options

| Option         | Short | Description                             | Example                  |
| -------------- | ----- | --------------------------------------- | ------------------------ |
| `--input`      | `-i`  | Path to input ARB file (English source) | `-i lib/l10n/app_en.arb` |
| `--languages`  | `-l`  | Comma-separated target language codes   | `-l fr,de,es,hi,ja`      |
| `--output-dir` | `-o`  | Custom output directory (optional)      | `-o translations/`       |
| `--verbose`    | `-v`  | Enable detailed logging                 | `-v`                     |
| `--help`       | `-h`  | Show help message                       | `-h`                     |

### Language Codes

Use standard ISO 639-1 language codes:

- `fr` - French
- `de` - German
- `es` - Spanish
- `hi` - Hindi
- `ja` - Japanese
- `ko` - Korean
- `zh` - Chinese
- `ar` - Arabic
- `pt` - Portuguese
- `ru` - Russian

## 📋 Input Format

Your source ARB file should follow the standard Flutter ARB format:

```json
{
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  },
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  },
  "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "@itemCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int",
        "example": "5"
      }
    }
  }
}
```

## 📤 Output

The tool generates translated ARB files with the following naming convention:

- Input: `app_en.arb`
- Output: `app_fr.arb`, `app_de.arb`, `app_es.arb`, etc.

### Example Output

```json
{
  "appTitle": "Mon Application",
  "@appTitle": {
    "description": "The title of the application"
  },
  "welcomeMessage": "Bienvenue, {name}!",
  "@welcomeMessage": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  },
  "itemCount": "{count, plural, =0{Aucun élément} =1{Un élément} other{{count} éléments}}",
  "@itemCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int",
        "example": "5"
      }
    }
  }
}
```

## 🔄 Smart Features

### Incremental Translation

The tool uses intelligent caching to only translate new or modified strings:

- **New strings**: Automatically detected and translated
- **Modified strings**: Re-translated when source text changes
- **Unchanged strings**: Preserved from existing translations
- **Removed strings**: Automatically cleaned up

### Batch Processing

To optimize API usage and reduce costs:

- Processes strings in configurable batches (default: 20 strings)
- Adds delays between batches to respect rate limits
- Provides progress feedback during batch processing

### Error Handling

- **Duplicate Detection**: Finds and removes duplicate keys
- **Conflict Resolution**: Reports conflicting duplicate keys
- **API Error Recovery**: Marks failed translations for manual review
- **Validation**: Ensures all required parameters are provided

## 🗂️ File Structure

```text
your_project/
├── lib/
│   └── l10n/
│       ├── app_en.arb      # Source file
│       ├── app_fr.arb      # Generated
│       ├── app_de.arb      # Generated
│       ├── app_es.arb      # Generated
│       └── .cache/         # Cache directory
│           └── app_en.arb  # Cached source
└── .env                    # API keys
```

## 🔧 Advanced Usage

### Custom Batch Size

Modify the batch size in the source code if needed:

```dart
// In lib/src/utils/batch_translator.dart
await batchTranslate(
  apiKey,
  stringsToTranslate,
  targetLang,
  batchSize: 10, // Reduce for rate-limited APIs
);
```

### Multiple API Keys

Switch between different AI services by updating your `.env` file:

```env
# Use Gemini (default)
GEMINI_API_KEY=your_gemini_key
```

## 📊 Example Workflow

1. **Prepare your source ARB file**:

   ```bash
   # Your English ARB file
   lib/l10n/app_en.arb
   ```

2. **Set up API key**:

   ```bash
   echo "GEMINI_API_KEY=your_api_key_here" > .env
   ```

3. **Run translation**:

   ```bash
   dart run localize_kit -i lib/l10n/app_en.arb -l fr,de,es,hi -v
   ```

4. **Review output**:

   ```bash
   ls lib/l10n/
   # app_en.arb  app_fr.arb  app_de.arb  app_es.arb  app_hi.arb
   ```

## 🔍 Troubleshooting

### Common Issues

1. **API Key Not Found**:

   ```text
   [ERROR] API Key is not set.
   ```

   - **Solution**: Ensure your `.env` file contains the correct API key

2. **Input File Not Found**:

   ```text
   [ERROR] Input file not found at path.
   ```

   - **Solution**: Verify the input file path is correct

3. **Invalid JSON Format**:

   ```text
   [ERROR] Failed to parse JSON file
   ```

   - **Solution**: Validate your ARB file JSON syntax

4. **Translation Failed**:

   ```text
   [WARNING] Failed to translate batch
   ```

   - **Solution**: Check your API key and internet connection

### Debug Mode

Enable verbose logging to see detailed information:

```bash
dart run localize_kit -i lib/l10n/app_en.arb -l fr,de,es -v
```

This will show:

- Detailed progress for each batch
- API request/response information
- Cache operations
- File operations

## 🤝 Contributing

We welcome contributions! Please feel free to submit issues, feature requests, or pull requests.

### Development Setup

```bash
git clone <repository-url>
cd localize_kit
dart pub get
dart run bin/localize_kit.dart --help
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with Dart and powered by AI translation services
- Supports Flutter's ARB localization format
- Designed for efficient batch processing and caching

---

## Made with ❤️ for the Flutter community
