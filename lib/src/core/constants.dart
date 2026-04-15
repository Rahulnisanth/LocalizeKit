const GEMINI_BASE_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

const PROMPT_HEADER =
    'You are a professional translator specializing in mobile app localization. Translate the following JSON ARB file strings from English to the following language(s):';

const PROMPT_BODY = '''
    Important instructions:
      1. Only translate the string values, not the keys or metadata
      2. Preserve all placeholders like {count} or {name}
      3. Maintain the original formatting, including line breaks and special characters
      4. Keep HTML tags intact if present
      5. Do not translate values in the metadata sections (starting with @)
      6. Preserve Dart string interpolation syntax like \${variable}
      7. Only output the translated JSON with no additional text or explanations
    Here is the JSON ARB content to translate:
    ''';
