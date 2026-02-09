# ZTP Template

## 1. Overview

ZTP Template은 NABP에서  
**실제 OS 배포 작업을 생성하기 위한 설계 단위(Design Template)** 입니다.

ZTP Template은  
Machine Group, Workflow, Network, Parameter 정보를 결합하여  
ZTP Dashboard에서 실행 가능한 배포 작업(Job)의 기준이 됩니다.

---

## 2. Role of ZTP Template

ZTP Template은 다음 역할을 수행합니다.

- 배포 설계 정보 정의
- Machine Group 매핑
- Workflow 및 Health Check 그룹 지정
- 배포 파라미터 관리
- Design Excel Import / Export 기준 제공

ZTP Template은  
배포 작업 이전에 반드시 생성되어야 합니다.

---

## 3. Access Path

ZTP Template은 다음 경로에서 설정합니다.

Operation  
→ ZTP Templates

---

## 4. ZTP Template Creation Flow

ZTP Template 생성은 다음 순서로 진행됩니다.

1. ZTP Templates → Create
2. 기본 정보 입력
3. Machine Group 설정
4. Health Check Group 설정
5. Network 및 기본 파라미터 설정
6. Design Template 생성
7. 저장 및 확정

---

## 5. Basic Information

### 5.1 Design Name

- ZTP Template을 식별하기 위한 이름
- 배포 작업(Job) 생성 시 사용

예시:
- centos7_compute_design
- almalinux9_login_design

---

### 5.2 Machine Group

- 배포에 사용할 Machine Group 지정
- OS, Workflow, Partition 정보 상속

---

### 5.3 Health Check Group

- Health Check 단계에서 사용할 Machine Group 지정
- 사전 점검 기준 정의

---

## 6. Network Configuration

ZTP Template에서는  
배포 대상 노드의 네트워크 정보를 정의합니다.

- Provisioning Network
- Subnet Network Address
- Netmask
- Gateway

네트워크 정보는  
Design Template과 결합되어 노드별로 확장됩니다.

---

## 7. Design Template (Excel)

ZTP Template 생성 후  
Design Template(Excel)을 통해  
실제 배포 대상 노드 정보를 정의합니다.

### 주요 항목

- Machine Type
- Provider Interface
- Hostname
- BMC MAC
- BMC IP
- Provisioning MAC
- Provisioning IP
- Provisioning Subnet Network
- Provisioning Subnet Netmask
- Provisioning Subnet Gateway

Excel 파일은  
Import / Export 방식으로 관리됩니다.

---

## 8. Common Design Parameters

ZTP Template은  
다음과 같은 공통 파라미터를 포함합니다.

- abp_workflow
- platform_setup
- proxy
- redfish_username
- redfish_password
- remote_ssh_password

파라미터는  
Workflow 실행 시 Template에 전달됩니다.

---

## 9. Workflow Integration

ZTP Template은  
Provisioning Workflow와 직접 연결됩니다.

- Workflow 단계별 실행 여부 설정
- Health Check / BIOS / OS Install 제어
- Platform Setup 단계 활성화 여부 지정

Workflow 설정은  
ZTP Dashboard Job 생성 시 검토됩니다.

---

## 10. Validation and Review

ZTP Template 생성 완료 후  
다음 항목을 검토해야 합니다.

- Machine Group 설정 여부
- Network 정보 정확성
- Design Excel 데이터 유효성
- Workflow 단계 설정

검토 완료 후  
ZTP Dashboard에서 배포 작업을 생성할 수 있습니다.

---

## 11. Best Practices

- ZTP Template은 용도별로 분리 관리
- Excel Import 전 데이터 검증
- Health Check Group 반드시 지정
- 대규모 배포 전 소규모 테스트 수행
- Template 변경 이력 관리

---

## 12. Common Issues

- Design Excel 형식 오류
- 네트워크 정보 불일치
- Machine Group 미지정
- Workflow 단계 누락
- 파라미터 미설정

문제 발생 시  
Design Template과 ZTP Template 설정을  
우선적으로 점검해야 합니다.

---

## 13. Relation to ZTP Dashboard

ZTP Template은  
ZTP Dashboard에서 배포 작업(Job)을 생성하는 기준입니다.

- 하나의 ZTP Template으로 여러 Job 생성 가능
- Job별 Provisioning Time 설정 가능
- Job 실행 결과는 Machines 화면에서 확인

---

## 14. Related Documents

- provisioning-workflow.md
- machine-group.md
- ztp-dashboard.md
- machines.md
