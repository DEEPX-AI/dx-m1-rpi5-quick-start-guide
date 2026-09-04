## Q1. Firmware Version Mismatch Error Message 

**Issue Description**  

When executing the AI demo application, the program terminates with a red `[dxrt-exception]` error message. This occurs when the current hardware firmware version is incompatible with the runtime library (`libdxrt`) requirements.  

<div align="left">
  <img src="./resources/Firmware_Version_Mismatch_Error.png" width="600">
  <p>Figure. Firmware Version Mismatch Error in Demo Execution</p>
</div>

**Cause**  

- **Version Conflict:** The system has detected that the installed firmware is lower than the minimum required version needed.  

**Solution**  

- To resolve this, you must perform a manual firmware upgrade to ensure the hardware can communicate correctly with the latest SDK features. Refer to **Section. Optional: Firmware Update**.  

---
