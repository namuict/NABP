# Machines

## 1. Overview

Machines는 NABP에서  
**개별 서버(Node)의 배포 상태, 하드웨어 정보, 실행 결과를 확인하는 화면**입니다.

Machines 화면은  
ZTP Dashboard에서 생성된 배포 작업의  
최종 결과를 확인하는 단계에 해당합니다.

---

## 2. Role of Machines

Machines는 다음 역할을 수행합니다.

- 개별 노드 배포 상태 확인
- Workflow 단계별 진행 결과 확인
- 배포 소요 시간 확인
- 하드웨어 정보 조회
- 배포 중 오류 및 Checkpoint 확인

Machines 화면은  
배포 성공 여부를 판단하는 기준 지점입니다.

---

## 3. Access Path

Machines 화면은 다음 경로에서 접근합니다.

ZTP Dashboard  
→ Job Name  
→ Machines

---

## 4. Machines List View

Machines List View에서는  
배포 대상 노드의 전체 목록을 확인할 수 있습니다.

### 표시 정보

- Hostname
- Machine Status
- Provisioning State
- Created Time
- Updated Time

상태 값은 다음과 같이 구분됩니다.

- Pending
- Processing
- Completed
- Failed

---

## 5. Machine Detail View

개별 Hostname을 선택하면  
Machine Detail View로 이동합니다.

Machine Detail View에서는  
해당 노드의 상세 정보를 확인할 수 있습니다.

---

## 6. Workflow Step Status

Machine Detail View에서는  
Workflow 단계별 상태를 확인할 수 있습니다.

기본 Workflow 단계는 다음과 같습니다.

- REGISTERING
- HEALTH_CHECK
- BIOS_SETUP
- OS_INSTALL
- PLATFORM_SETUP
- DEPLOYED

각 단계별로  
상태(Status)와 결과를 확인할 수 있습니다.

---

## 7. Step Duration and Checkpoints

각 Workflow 단계에 대해  
다음 정보를 확인할 수 있습니다.

- 단계별 소요 시간
- 단계별 실행 결과
- NABP로 전달된 Checkpoint 메시지

Checkpoint 정보는  
배포 문제 분석에 중요한 자료로 활용됩니다.

---

## 8. Hardware Information

Machines 화면에서는  
다음과 같은 하드웨어 정보를 확인할 수 있습니다.

- CPU 정보
- Memory 정보
- Storage 정보
- Network 정보
- Mainboard 정보
- System 정보

해당 정보는  
REGISTERING 단계에서 수집됩니다.

---

## 9. Console Access

Machines 화면에서는  
해당 노드의 Virtual Console에 접근할 수 있습니다.

- BMC 기반 Console 연결
- OS 설치 과정 실시간 확인 가능
- 문제 발생 시 즉시 확인 가능

Console 기능은  
배포 중 장애 분석에 활용됩니다.

---

## 10. Take Action

Machines 화면에서는  
개별 노드에 대해 다음 작업을 수행할 수 있습니다.

- 실패한 Step 재실행
- 배포 중단
- 상태 재확인

Take Action 기능을 통해  
부분적인 재시도가 가능합니다.

---

## 11. Common Failure Scenarios

Machines 화면에서 자주 확인되는 오류 유형은 다음과 같습니다.

- Health Check 실패
- BIOS 설정 실패
- Installation Media 접근 실패
- Network 설정 오류
- OS 설치 중 오류

각 오류는  
Checkpoint 메시지를 통해 확인할 수 있습니다.

---

## 12. Best Practices

- 배포 완료 후 Machines 상태 점검
- Failed 노드는 Checkpoint 우선 확인
- Step Duration을 통한 병목 분석
- Console 접근을 통한 실시간 확인
- 대규모 배포 시 상태 필터 활용

---

## 13. Related Documents

- ztp-template.md
- ztp-dashboard.md
- provisioning-workflow.md
- machine-group.md
