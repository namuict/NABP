# Machine Group

## 1. Overview

Machine Group은 NABP에서  
**동일한 특성과 설정을 갖는 서버 집합을 정의하는 구성 요소**입니다.

Machine Group을 통해 OS, 네트워크, 파라미터, 워크플로우 설정을  
여러 노드에 일괄 적용할 수 있으며,  
ZTP 기반 자동 배포의 핵심 단위로 사용됩니다.

Machine Group은 NABP 설정 과정의 **마지막 단계**에 해당합니다.

---

## 2. Role of Machine Group

Machine Group은 다음과 같은 역할을 수행합니다.

- 배포 대상 서버의 공통 속성 정의
- OS 및 Installation Media 연결
- Partition Table 지정
- Provisioning Workflow 연계
- ZTP Template 생성 시 기준 정보 제공
- 배포 시 노드별 파라미터 자동 적용

---

## 3. Configuration Path

Machine Group은 다음 경로에서 설정합니다.

Contents  
→ Machine Group

---

## 4. Machine Group Creation Flow

Machine Group 생성은 다음 순서로 진행됩니다.

1. Parent Machine Group 선택 (선택 사항)
2. Machine Group Name 지정
3. Operating System 설정
4. Network / Boot 설정
5. Parameters 설정

---

## 5. Basic Information

### 5.1 Parent Machine Group

- 기존 Machine Group을 상속하여 설정 가능
- 공통 설정을 재사용할 수 있음
- 계층적 구조로 관리 가능

---

### 5.2 Name

- Machine Group을 식별하기 위한 이름
- 일반적으로 OS 및 용도를 포함하여 작성

예시:
- centos7_compute
- almalinux9_login
- diskless_compute_nodes

---

## 6. Operating System Configuration

Machine Group에서는 다음 OS 관련 항목을 설정합니다.

- Architecture  
  예: x86_64

- Operating System  
  이전 단계에서 정의한 OS 선택

- Installation Media  
  OS 설치에 사용할 Media 선택

- Partition Table  
  OS 설치 시 사용할 Partition Template 지정

- Bootloader  
  예: Grub2 UEFI

- Root Password  
  설치될 OS의 root 계정 비밀번호

---

## 7. Network Configuration

Machine Group은 배포 시 사용할 네트워크 정보를 포함합니다.

- Provisioning Network
- Provisioning IP / Netmask / Gateway
- BMC Network 정보 (필요 시)

네트워크 정보는  
ZTP Template 및 Design Excel 파일을 통해  
노드별로 확장 적용됩니다.

---

## 8. Parameters Configuration

Parameters는 Machine Group의 가장 중요한 요소 중 하나입니다.

### 8.1 Parameter Types

다음과 같은 파라미터 타입을 지원합니다.

- Boolean
- Integer
- Real
- String
- Array
- YAML

---

### 8.2 Common Parameters

Machine Group에서 정의된 파라미터는  
Workflow 및 Template에서 참조됩니다.

예시:
- abp_workflow
- platform_type
- hypervisor_type
- custom flags

---

### 8.3 ABP Workflow Parameter

`abp_workflow` 파라미터는  
배포 단계별 실행 여부 및 순서를 정의합니다.

예시 단계:

- REGISTERING  
  하드웨어 정보 수집 및 BMC 기본 설정

- HEALTH_CHECK  
  CPU, Memory, Disk, Network 사전 점검

- BIOS_SETUP  
  BIOS 설정 자동화

- OS_INSTALL  
  OS 설치 단계

- HYPERVISOR_INSTALL  
  Hypervisor 설치 (선택)

- PLATFORM_SETUP  
  Post OS Installation 작업

- DEPLOYED  
  배포 완료 단계

각 단계는 enabled / disabled 설정이 가능합니다.

---

## 9. Usage in ZTP Templates

Machine Group은 ZTP Template 생성 시 다음 용도로 사용됩니다.

- 배포 대상 서버 유형 정의
- Health Check Group 지정
- Provisioning Workflow 연결
- 노드별 파라미터 자동 매핑

ZTP Template은  
Machine Group을 기반으로 생성되며,  
Design 단계에서 실제 노드 정보와 결합됩니다.

---

## 10. Best Practices

- 역할별로 Machine Group 분리 (Login / Compute / Storage)
- Diskfull / Diskless 환경 분리 관리
- Health Check 전용 Machine Group 구성
- Parent Machine Group 활용으로 중복 최소화
- 파라미터 변경 시 사전 테스트 수행

---

## 11. Common Issues

- OS 및 Installation Media 불일치
- Partition Template 오류
- 파라미터 누락 또는 타입 불일치
- Workflow 단계 설정 오류

문제 발생 시  
Machine Group 설정과 파라미터 정의를  
우선적으로 점검해야 합니다.

---

## 12. Related Configuration

Machine Group은 다음 구성 요소와 밀접하게 연관됩니다.

- Installation Media
- Operating System
- Partition Table
- Provisioning Workflow
- ZTP Template
- ZTP Dashboard
