# ZTP Dashboard

## 1. Overview

ZTP Dashboard는 NABP에서  
**실제 OS 배포 작업(Job)을 생성하고 실행 상태를 관리하는 운영 화면**입니다.

ZTP Dashboard는  
ZTP Template을 기반으로 배포 작업을 생성하며,  
Operator가 배포 전 과정의 상태를 모니터링하는 중심 화면입니다.

---

## 2. Role of ZTP Dashboard

ZTP Dashboard는 다음 역할을 수행합니다.

- ZTP Template 기반 배포 작업 생성
- 배포 작업(Job) 실행 및 제어
- 배포 상태 실시간 모니터링
- 노드별 Workflow 상태 집계
- 배포 결과 확인 및 실패 분석

---

## 3. Access Path

ZTP Dashboard는 다음 경로에서 접근합니다.

Operation  
→ ZTP Dashboard

---

## 4. ZTP Dashboard Main View

ZTP Dashboard Main View에서는  
생성된 배포 작업(Job) 목록을 확인할 수 있습니다.

### 표시 정보

- Job Name
- Status
- Total Nodes
- Completed Nodes
- Failed Nodes
- Created Time

---

## 5. Job Status

배포 작업(Job)의 상태는 다음과 같이 구분됩니다.

- Pending  
- Processing  
- Completed  
- Failed  

상태는  
전체 노드의 Workflow 진행 상황을 기준으로 계산됩니다.

---

## 6. Create ZTP Job

ZTP Dashboard에서는  
기존에 생성된 ZTP Template을 사용하여  
새로운 배포 작업(Job)을 생성합니다.

### 생성 절차

1. ZTP Dashboard → Create
2. ZTP Template 선택
3. Workflow 단계 확인
4. Provisioning Time 설정
5. Review 및 Job Name 지정
6. Submit

---

## 7. Workflow Review

Job 생성 과정 중  
Workflow Review 화면을 통해  
다음 항목을 확인할 수 있습니다.

- 실행될 Workflow 단계
- 단계별 Template 목록
- 활성 / 비활성 단계 여부
- Template 실행 순서

원하지 않는 단계는  
비활성화하여 실행에서 제외할 수 있습니다.

---

## 8. Provisioning Time

ZTP Dashboard에서는  
배포 작업의 Provisioning Time을 설정할 수 있습니다.

- 즉시 실행
- 예약 실행

Provisioning Time은  
대규모 배포 시 자원 분산을 위해 활용됩니다.

---

## 9. Job Execution

Job이 실행되면  
ZTP Dashboard에서 다음 정보를 확인할 수 있습니다.

- 전체 진행률
- 노드별 상태 집계
- 단계별 진행 상태

배포는  
노드 단위로 병렬 실행됩니다.

---

## 10. Job Detail View

Job Name을 선택하면  
Job Detail View로 이동합니다.

Job Detail View에서는  
다음 정보를 확인할 수 있습니다.

- Workflow 단계별 상태
- 노드별 진행 현황
- Completed / Failed 노드 수

---

## 11. Transition to Machines

Job Detail View에서  
개별 노드를 선택하면  
Machines 화면으로 이동합니다.

Machines 화면에서는  
노드 단위의 상세 배포 결과를 확인할 수 있습니다.

---

## 12. Failure Handling

ZTP Dashboard에서는  
배포 실패 상황을 다음 방식으로 처리합니다.

- Failed 노드 표시
- 실패 단계 식별
- Machines 화면을 통한 상세 분석
- 필요 시 재실행(Take Action)

---

## 13. Best Practices

- 대규모 배포 전 소규모 테스트 Job 실행
- Workflow Review 단계 필수 확인
- Failed 노드 우선 분석
- Provisioning Time을 활용한 배포 분산
- 배포 완료 후 Machines 화면 확인

---

## 14. Related Documents

- ztp-template.md
- machines.md
- provisioning-workflow.md
- machine-group.md
