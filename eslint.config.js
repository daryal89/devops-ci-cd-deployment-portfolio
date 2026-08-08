export default [
  {
    ignores: [
      'node_modules/**',
      'coverage/**'
    ]
  },
  {
    files: [
      'src/**/*.js',
      'test/**/*.js',
      '*.config.js'
    ],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: {
        console: 'readonly',
        process: 'readonly'
      }
    },
    rules: {
      'no-undef': 'error',
      'no-unused-vars': [
        'error',
        {
          args: 'after-used',
          argsIgnorePattern: '^_'
        }
      ],
      'eqeqeq': 'error',
      'curly': [
        'error',
        'all'
      ],
      'semi': [
        'error',
        'always'
      ],
      'quotes': [
        'error',
        'single',
        {
          avoidEscape: true
        }
      ]
    }
  }
];
