# NABP Overview

## 1. What is NABP?

**NABP (NamuICT Automated Baremetal Provisioning)** 는  
초고성능컴퓨팅(HPC) 및 대규모 데이터센터 환경에서  
베어메탈 서버를 자동으로 설치·운영하기 위한  
**Zero Touch Provisioning (ZTP)** 기반 프로비저닝 자동화 소프트웨어입니다.

NABP는 수작업 중심의 OS 설치 및 초기 설정 과정을 제거하고,  
사전에 정의된 템플릿과 워크플로우를 기반으로  
대규모 서버 환경을 일관되고 안정적으로 구축하는 것을 목표로 합니다.

---

## 2. Why NABP?

대규모 서버 환경에서는 다음과 같은 문제가 반복적으로 발생합니다.

- 수십~수천 노드의 OS 설치에 많은 시간과 인력 소요
- 설치 과정 중 사람의 실수로 인한 설정 불일치
- BIOS, BMC, 네트워크, OS 설정의 복잡성
- 배포 실패 원인 추적의 어려움
- 폐쇄망 환경에서의 OS 설치 제약

NABP는 이러한 문제를 해결하기 위해 설계되었습니다.

- ZTP 기반 자동화 배포
- Template 기반 재사용 가능한 배포 로직
- 배포 단계별 상태 및 체크포인트 추적
- Diskfull / Diskless 서버 환경 동시 지원
- 폐쇄망 환경 대응 구조

---

## 3. Key Concepts

### 3.1 Zero Touch Provisioning (ZTP)

ZTP는 사람이 직접 개입하지 않아도  
서버 전원이 켜지는 순간부터 OS 설치 및 초기 설정까지  
자동으로 완료되는 프로비저닝 방식을 의미합니다.

NABP는 PXE, DHCP, BMC, BIOS 제어를 결합하여  
완전 자동화된 ZTP 환경을 제공합니다.

---

### 3.2 Template-Based Design

NABP에서 모든 배포 로직은 **Template** 으로 정의됩니다.

- Partition Template
- Provisioning Template (Kickstart, Preseed 등)
- BIOS Setup Template
- Platform Setup Template

Template은 재사용 가능하며,  
다양한 OS와 환경에 맞게 조합될 수 있습니다.

---

### 3.3 Workflow-Oriented Provisioning

Workflow는 여러 Template을  
순서와 조건에 따라 실행하도록 정의한 배포 단위입니다.

이를 통해 NABP는 다음과 같은 배포 흐름을 구성합니다.

REGISTERING  
→ HEALTH_CHECK  
→ BIOS_SETUP  
→ OS_INSTALL  
→ PLATFORM_SETUP  
→ DEPLOYED

각 단계는 활성/비활성 설정이 가능하며  
배포 환경에 맞게 유연하게 구성할 수 있습니다.

---

## 4. Supported Environments

NABP는 다음과 같은 환경을 지원합니다.

- 대규모 HPC 클러스터
- 일반 데이터센터 서버 환경
- Diskfull 서버
- Diskless 서버
- 폐쇄망(Closed Network) 환경

### Supported Linux OS

- Red Hat Enterprise Linux
- CentOS
- Rocky Linux
- Alma Linux
- Ubuntu
- Debian
- SUSE Linux
- Oracle Linux

---

## 5. Typical Usage Flow

NABP를 이용한 OS 배포는 크게 두 단계로 나뉩니다.

### 5.1 Configuration (Administrator)

- Subnets 설정
- Installation Media 설정
- Partition Table 정의
- Provisioning Workflow 구성
- Operating System 정의
- Machine Group 생성

---

### 5.2 Operation (Operator)

- ZTP Template 생성
- ZTP Dashboard에서 배포 작업 생성
- 배포 진행 상태 모니터링
- 노드별 결과 및 로그 확인

---

## 6. What This Documentation Covers

이 문서는 NABP의 개념과 전체 흐름을 이해하기 위한 문서입니다.

- NABP의 목적과 배경
- 핵심 개념 및 설계 철학
- 전체 배포 흐름 개요

세부 설정 방법 및 운영 절차는  
Administrator Guide 및 Operator Guide에서 다룹니다.

---

## 7. Version Information

- NABP Version: v3.5.0
- Document Version: v1.0
- Last Updated: 2026-02-09
