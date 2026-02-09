# Provisioning Guide (Administrator)

## 1. Overview

본 문서는 NABP에서  
**관리자(Admin)가 OS 프로비저닝을 수행하기 위해 사전에 구성해야 할  
전체 설정 절차를 단계별로 설명**합니다.

Provisioning Guide는  
NABP 초기 구축 및 운영 환경 준비를 위한 기준 문서입니다.

---

## 2. Provisioning Concept

NABP의 OS 배포는 다음 두 단계로 구분됩니다.

- Configuration (Administrator)
- Operation (Operator)

본 문서는 Configuration 단계에 초점을 맞춥니다.

---

## 3. Overall Configuration Flow

관리자는 다음 순서로 설정을 진행해야 합니다.

1. Login
2. Subnets
3. Installation Media
4. Partition Table
5. Provisioning Workflow
6. Operating System
7. Machine Group

모든 단계가 완료되어야  
ZTP 기반 OS 배포를 수행할 수 있습니다.

---

## 4. Login

관리자는 로그인 후  
NABP의 모든 Configuration 기능에 접근할 수 있습니다.

- 기본 관리자 계정으로 로그인
- 초기 로그인 후 비밀번호 변경 권장

---

## 5. Subnets Configuration

Subnets는  
OS 설치에 사용될 네트워크 대역을 정의합니다.

Subnets 설정을 통해 다음이 결정됩니다.

- Provisioning Network 대역
- DHCP Proxy 연계
- IP 할당 범위

---

## 6. Installation Media Configuration

Installation Media는  
OS 설치에 필요한 Repository 및 이미지 경로를 정의합니다.

- OS 설치 이미지 제공
- Health Check 단계에서 사용되는 Live OS 제공
- 폐쇄망 환경에서는 내부 Repository 필수

---

## 7. Partition Table Configuration

Partition Table은  
OS 설치 시 디스크 구성 방식을 정의합니다.

- Diskfull / Diskless 환경 구분
- 기본 Template 또는 Custom Template 사용
- OS 안정성에 직접적인 영향

---

## 8. Provisioning Workflow Configuration

Provisioning Workflow는  
OS 배포에 사용되는 실행 절차를 정의합니다.

Workflow는 여러 Template을  
순서와 조건에 따라 실행하도록 구성됩니다.

기본 Workflow 단계는 다음과 같습니다.

REGISTERING  
→ HEALTH_CHECK  
→ BIOS_SETUP  
→ OS_INSTALL  
→ PLATFORM_SETUP  
→ DEPLOYED

---

## 9. Operating System Configuration

Operating System은  
실제 배포될 OS 설치 정의를 관리합니다.

- Installation Media 연결
- Partition Table 연결
- Provisioning Workflow 연결
- OS별 Template 설정

---

## 10. Machine Group Configuration

Machine Group은  
동일한 설정을 공유하는 서버 집합을 정의합니다.

Machine Group을 통해 다음이 가능합니다.

- OS 및 Network 설정 일괄 적용
- Workflow 파라미터 정의
- ZTP Template 생성 기준 제공

---

## 11. Configuration Validation

모든 Configuration 단계 완료 후  
다음 항목을 점검해야 합니다.

- Installation Media 접근 가능 여부
- Partition Template 정상 여부
- Workflow 단계 활성 여부
- OS 및 Machine Group 연결 상태

설정 오류가 있을 경우  
배포는 정상적으로 진행되지 않습니다.

---

## 12. Transition to Operation

Configuration 단계가 완료되면  
운영자는 Operation 단계로 이동합니다.

Operation 단계에서는 다음 작업이 수행됩니다.

- ZTP Template 생성
- ZTP Dashboard에서 배포 작업 생성
- Machines 상태 모니터링

---

## 13. Best Practices

- Configuration 변경 시 사전 테스트 수행
- Production / Test 환경 분리 운영
- Template 수정 시 변경 이력 관리
- 폐쇄망 환경은 Media Path 우선 점검

---

## 14. Related Documents

- overview.md
- architecture.md
- installation-media.md
- partition.md
- os.md
- machine-group.md
