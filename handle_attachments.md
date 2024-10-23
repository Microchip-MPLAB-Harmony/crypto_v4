# Purpose

The purpose of this file is to handle components that are connected to `lib_crypto`. wolfCrypt is the main example currently.

## Steps for Extending `lib_crypto` Functionality

1. **Create a folder** (e.g., `Module_Wolfcrypt`) for the component.
2. **Build the component** that populates its menus.
3. **Create file symbols** for files and handle enable/disable of it's own files
4. **Create bool symbols** for files to be able to update the FreeMarker Templates 
5. **Use `sendMessage()`** to `lib_crypto` to enable the necessary API files:
   - Specify which `fileCategories` should be enabled
   - **TODO**: Allowing HW files request if the component is not an independent SW implementation.
   - `lib_crypto` will save this request into a global data structure and reference it during every "generate" call.

### Example:
```
Crypto_Attached_Category_Reqs{ 
    key : algoSet()
    lib_wolfcrypt : (HashAlgo, SymAlgo, AeadAlgo)
    lib_something : (RngAlgo)
}
```

## Notes

- Ensure the `<Module name="Wolfcrypt_Lib" ...>` and `Module.CreateComponent("lib_wolfcrypt", ...)` names are the same.
- Ensure `sendMessage` sends a dictionary with only one key-value pair. It’s unclear how it would handle multiple key-value pairs.
